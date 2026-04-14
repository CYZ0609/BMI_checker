import '../models/food_model.dart';
import '../models/goal_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DietService {
  static const String _apiKey = 'YOUR_USDA_KEY_HERE';

  // 主方法：同时接收 BMI 类别和目标
  static Future<List<FoodItem>> getRecommendations(
    String bmiCategory, {
    UserGoal? goal,
  }) async {
    final queries = _getQueries(bmiCategory, goal);

    try {
      final futures = queries.map((q) => _fetchBestMatch(q, bmiCategory, goal));
      final results = await Future.wait(futures);
      final recommendations = results.whereType<FoodItem>().toList();
      return recommendations.isNotEmpty
          ? recommendations
          : _fallback(bmiCategory, goal);
    } catch (e) {
      return _fallback(bmiCategory, goal);
    }
  }

  // 根据 BMI + 目标 组合决定搜索关键词
  static List<String> _getQueries(String bmiCategory, UserGoal? goal) {
    // 目标优先，BMI 作为辅助过滤
    if (goal == UserGoal.buildMuscle) {
      return ['chicken breast', 'egg', 'greek yogurt', 'tuna', 'brown rice'];
    }
    if (goal == UserGoal.loseWeight) {
      return ['broccoli', 'spinach', 'cucumber', 'lettuce', 'celery'];
    }
    if (goal == UserGoal.improveStamina) {
      return ['oatmeal', 'banana', 'sweet potato', 'quinoa', 'salmon'];
    }
    if (goal == UserGoal.stayHealthy) {
      return ['apple', 'yogurt', 'broccoli', 'salmon', 'oatmeal'];
    }

    // 没有设目标，用 BMI 类别决定
    switch (bmiCategory) {
      case 'Underweight': return ['chicken', 'rice', 'egg', 'avocado', 'peanut butter'];
      case 'Normal':      return ['oatmeal', 'salmon', 'banana', 'yogurt', 'broccoli'];
      case 'Overweight':  return ['broccoli', 'chicken breast', 'spinach', 'cucumber', 'egg'];
      case 'Obese':       return ['lettuce raw', 'celery', 'cabbage', 'tomato', 'spinach'];
      default:            return ['apple', 'banana', 'orange', 'milk', 'bread'];
    }
  }

  static Future<FoodItem?> _fetchBestMatch(
    String query,
    String bmiCategory,
    UserGoal? goal,
  ) async {
    final uri = Uri.parse(
      'https://api.nal.usda.gov/fdc/v1/foods/search'
      '?query=${Uri.encodeComponent(query)}'
      '&pageSize=5'
      '&dataType=Foundation,SR%20Legacy'
      '&api_key=$_apiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data  = jsonDecode(response.body) as Map<String, dynamic>;
    final foods = data['foods'] as List<dynamic>? ?? [];
    final blackList = ['fast', 'cookie', 'cake', 'candy', 'fried', 'syrup', 'ice cream', 'burger'];

    for (var f in foods) {
      final item      = _parse(f as Map<String, dynamic>);
      final nameLower = item.name.toLowerCase();

      if (item.name.trim().isNotEmpty &&
          item.calories > 0 &&
          _isAppropriate(bmiCategory, goal, item) &&
          !blackList.any((bad) => nameLower.contains(bad))) {
        return item;
      }
    }
    return null;
  }

  // 根据目标 + BMI 判断食物是否合适
  static bool _isAppropriate(String bmiCategory, UserGoal? goal, FoodItem item) {
    if (goal == UserGoal.buildMuscle) {
      return item.protein > 10; // 高蛋白
    }
    if (goal == UserGoal.loseWeight) {
      return item.calories < 100; // 低卡
    }
    if (goal == UserGoal.improveStamina) {
      return item.carbs > 10 || item.protein > 8; // 复合碳水或蛋白
    }
    // 没目标用 BMI 过滤
    switch (bmiCategory) {
      case 'Obese':       return item.calories < 100;
      case 'Overweight':  return item.calories < 200;
      case 'Underweight': return item.calories > 150;
      default:            return true;
    }
  }

  static FoodItem _parse(Map<String, dynamic> food) {
    final nutrients = food['foodNutrients'] as List<dynamic>? ?? [];

    double get(int id) {
      try {
        final n = nutrients.firstWhere(
          (n) => (n as Map)['nutrientId'] == id,
        ) as Map;
        return (n['value'] ?? 0).toDouble();
      } catch (_) {
        return 0.0;
      }
    }

    String cleanName(String raw) {
      final shortName = raw.split(',').take(2).join(' ').trim();
      if (shortName.isEmpty) return '';
      return shortName
          .toLowerCase()
          .split(' ')
          .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
          .join(' ');
    }

    return FoodItem(
      name:     cleanName(food['description'] ?? ''),
      calories: get(1008),
      protein:  get(1003),
      fat:      get(1004),
      carbs:    get(1005),
      tip:      _tip(get(1008), get(1003)),
    );
  }

  static String _tip(double kcal, double protein) {
    if (protein > 20) return 'Excellent protein source — great for muscle building.';
    if (kcal < 50)    return 'Very low calorie — ideal for weight loss.';
    if (kcal < 150)   return 'Low calorie and nutritious.';
    if (kcal > 400)   return 'Calorie-dense — good for gaining weight.';
    return 'Nutritious and suitable for your goal.';
  }

  // 本地备用数据（API 失败自动使用）
  static List<FoodItem> _fallback(String bmiCategory, UserGoal? goal) {
    // 目标优先
    if (goal == UserGoal.buildMuscle) {
      return [
        FoodItem(name: 'Grilled Chicken Breast', calories: 165, protein: 31,  fat: 3.6, carbs: 0,   tip: 'Lean protein — essential for muscle growth.'),
        FoodItem(name: 'Whole Egg',              calories: 155, protein: 13,  fat: 11,  carbs: 1.1, tip: 'Complete amino acid profile.'),
        FoodItem(name: 'Greek Yogurt',           calories: 59,  protein: 10,  fat: 0.4, carbs: 3.6, tip: 'High protein, easy to digest.'),
        FoodItem(name: 'Tuna',                   calories: 116, protein: 26,  fat: 1,   carbs: 0,   tip: 'Very high protein, low fat.'),
        FoodItem(name: 'Brown Rice',             calories: 216, protein: 5,   fat: 1.8, carbs: 45,  tip: 'Complex carbs for training energy.'),
      ];
    }
    if (goal == UserGoal.loseWeight) {
      return [
        FoodItem(name: 'Mixed Green Salad', calories: 20,  protein: 1.5, fat: 0.3, carbs: 3,   tip: 'Very low calorie — eat freely.'),
        FoodItem(name: 'Cucumber',          calories: 16,  protein: 0.7, fat: 0.1, carbs: 3.6, tip: 'Almost zero calories, keeps you hydrated.'),
        FoodItem(name: 'Spinach',           calories: 23,  protein: 2.9, fat: 0.4, carbs: 3.6, tip: 'Low calorie and rich in iron.'),
        FoodItem(name: 'Celery',            calories: 16,  protein: 0.7, fat: 0.2, carbs: 3,   tip: 'Almost no calories — great snack.'),
        FoodItem(name: 'Boiled Egg',        calories: 78,  protein: 6,   fat: 5,   carbs: 0.6, tip: 'Filling protein with few carbs.'),
      ];
    }
    if (goal == UserGoal.improveStamina) {
      return [
        FoodItem(name: 'Oatmeal',       calories: 68,  protein: 2.4, fat: 1.4, carbs: 12,  tip: 'Slow-release energy for endurance.'),
        FoodItem(name: 'Banana',        calories: 89,  protein: 1.1, fat: 0.3, carbs: 23,  tip: 'Quick energy boost before a run.'),
        FoodItem(name: 'Sweet Potato',  calories: 86,  protein: 1.6, fat: 0.1, carbs: 20,  tip: 'Complex carbs for sustained performance.'),
        FoodItem(name: 'Grilled Salmon',calories: 208, protein: 20,  fat: 13,  carbs: 0,   tip: 'Omega-3 reduces muscle inflammation.'),
        FoodItem(name: 'Brown Rice',    calories: 216, protein: 5,   fat: 1.8, carbs: 45,  tip: 'Great carb source for training days.'),
      ];
    }
    if (goal == UserGoal.stayHealthy) {
      return [
        FoodItem(name: 'Oatmeal',      calories: 68,  protein: 2.4, fat: 1.4, carbs: 12,  tip: 'Great breakfast, keeps you full longer.'),
        FoodItem(name: 'Apple',        calories: 52,  protein: 0.3, fat: 0.2, carbs: 14,  tip: 'Low calorie snack rich in fibre.'),
        FoodItem(name: 'Broccoli',     calories: 34,  protein: 2.8, fat: 0.4, carbs: 7,   tip: 'High in vitamins C and K.'),
        FoodItem(name: 'Greek Yogurt', calories: 59,  protein: 10,  fat: 0.4, carbs: 3.6, tip: 'Good for gut health.'),
        FoodItem(name: 'Grilled Salmon',calories:208, protein: 20,  fat: 13,  carbs: 0,   tip: 'Rich in omega-3 for heart health.'),
      ];
    }

    // 没有目标，用 BMI fallback
    final data = {
      'Underweight': [
        FoodItem(name: 'Grilled Chicken Breast', calories: 165, protein: 31,  fat: 3.6, carbs: 0,   tip: 'High protein helps build muscle.'),
        FoodItem(name: 'Brown Rice',             calories: 216, protein: 5,   fat: 1.8, carbs: 45,  tip: 'Complex carbs for energy.'),
        FoodItem(name: 'Avocado',                calories: 160, protein: 2,   fat: 15,  carbs: 9,   tip: 'Healthy fats increase calorie intake.'),
        FoodItem(name: 'Peanut Butter',          calories: 588, protein: 25,  fat: 50,  carbs: 20,  tip: 'Calorie-dense and easy to add to meals.'),
        FoodItem(name: 'Whole Egg',              calories: 155, protein: 13,  fat: 11,  carbs: 1.1, tip: 'Complete protein source.'),
      ],
      'Normal': [
        FoodItem(name: 'Oatmeal',        calories: 68,  protein: 2.4, fat: 1.4, carbs: 12,  tip: 'Keeps you full longer.'),
        FoodItem(name: 'Grilled Salmon', calories: 208, protein: 20,  fat: 13,  carbs: 0,   tip: 'Rich in omega-3.'),
        FoodItem(name: 'Banana',         calories: 89,  protein: 1.1, fat: 0.3, carbs: 23,  tip: 'Natural energy boost.'),
        FoodItem(name: 'Greek Yogurt',   calories: 59,  protein: 10,  fat: 0.4, carbs: 3.6, tip: 'High protein, good for gut health.'),
        FoodItem(name: 'Broccoli',       calories: 34,  protein: 2.8, fat: 0.4, carbs: 7,   tip: 'High in fibre and vitamins.'),
      ],
      'Overweight': [
        FoodItem(name: 'Steamed Broccoli',       calories: 34,  protein: 2.8, fat: 0.4, carbs: 7,   tip: 'Low calorie, high fibre.'),
        FoodItem(name: 'Grilled Chicken Breast', calories: 165, protein: 31,  fat: 3.6, carbs: 0,   tip: 'Lean protein keeps you full.'),
        FoodItem(name: 'Spinach',                calories: 23,  protein: 2.9, fat: 0.4, carbs: 3.6, tip: 'Very low calorie, rich in iron.'),
        FoodItem(name: 'Cucumber',               calories: 16,  protein: 0.7, fat: 0.1, carbs: 3.6, tip: 'Almost zero calories.'),
        FoodItem(name: 'Boiled Egg',             calories: 78,  protein: 6,   fat: 5,   carbs: 0.6, tip: 'Filling protein snack.'),
      ],
      'Obese': [
        FoodItem(name: 'Mixed Green Salad',       calories: 20,  protein: 1.5, fat: 0.3, carbs: 3,   tip: 'Very low calorie.'),
        FoodItem(name: 'Celery',                  calories: 16,  protein: 0.7, fat: 0.2, carbs: 3,   tip: 'Almost no calories.'),
        FoodItem(name: 'Skinless Chicken Breast', calories: 110, protein: 23,  fat: 1.2, carbs: 0,   tip: 'Lowest fat protein option.'),
        FoodItem(name: 'Steamed Broccoli',        calories: 34,  protein: 2.8, fat: 0.4, carbs: 7,   tip: 'Fill your plate with this.'),
        FoodItem(name: 'Plain Greek Yogurt',      calories: 59,  protein: 10,  fat: 0.4, carbs: 3.6, tip: 'High protein, avoid flavoured.'),
      ],
    };
    return data[bmiCategory] ?? data['Normal']!;
  }
}