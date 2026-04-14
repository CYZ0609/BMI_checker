import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

class DietService {
  static const String _apiKey = 'sOcSxjGlAoSgOMixhIoUrjwrdjekqY0m4yfd28hy'; // 你的 Key

  static Future<List<FoodItem>> getRecommendations(String bmiCategory) async {
    // 获取当前 BMI 类别需要搜索的 5 个关键词
    final queries = _getQueries(bmiCategory);

    try {
      // 🌟 高级技巧：使用 Future.wait 并发请求 5 个不同的食物，速度极快！
      final futures = queries.map((q) => _fetchBestMatch(q, bmiCategory));
      final results = await Future.wait(futures);

      // 把结果里为 null 的（也就是没找到合适食物的）过滤掉
      final recommendations = results.whereType<FoodItem>().toList();

      // API 有有效数据就用，没有就用本地备用
      return recommendations.isNotEmpty ? recommendations : _fallback(bmiCategory);

    } catch (e) {
      // 网络断了或其他异常
      return _fallback(bmiCategory);
    }
  }

  // 🌟 修改点 1：为每个体型定制 5 个完全不同的健康食材，保证列表多样性
  static List<String> _getQueries(String category) {
    switch (category) {
      case 'Underweight': return ['chicken', 'rice', 'egg', 'avocado', 'peanut butter'];
      case 'Normal':      return ['oatmeal', 'salmon', 'banana', 'yogurt', 'broccoli'];
      case 'Overweight':  return ['broccoli', 'chicken breast', 'spinach', 'cucumber', 'egg'];
      case 'Obese':       return ['lettuce raw', 'celery', 'cabbage', 'tomato', 'spinach'];
      default:            return ['apple', 'banana', 'orange', 'milk', 'bread'];
    }
  }

  // 🌟 修改点 2：专门为 1 个关键词找 1 个最完美的食物
  static Future<FoodItem?> _fetchBestMatch(String query, String bmiCategory) async {
    final uri = Uri.parse(
      'https://api.nal.usda.gov/fdc/v1/foods/search'
      '?query=${Uri.encodeComponent(query)}'
      '&pageSize=5' // 每个关键词只需看前5个备选
      '&dataType=Foundation,SR%20Legacy'
      '&api_key=$_apiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final foods = data['foods'] as List<dynamic>? ?? [];
    final blackList = ['fast', 'cookie', 'cake', 'candy', 'fried', 'syrup', 'ice cream', 'taco', 'burger'];

    for (var f in foods) {
      final item = _parse(f as Map<String, dynamic>);
      final nameLower = item.name.toLowerCase();

      // 严苛的过滤条件：
      // 1. 名字不能为空 (修复你截图里的幽灵项)
      // 2. 卡路里符合 BMI 要求
      // 3. 不包含垃圾食品关键词
      if (item.name.trim().isNotEmpty && 
          item.calories > 0 &&
          _isCalorieAppropriate(bmiCategory, item.calories) &&
          !blackList.any((bad) => nameLower.contains(bad))) {
        
        return item; // 找到第一个完美的，立刻返回！
      }
    }
    return null; // 如果这个关键词没找到合适的，返回 null
  }

  static bool _isCalorieAppropriate(String category, double calories) {
    switch (category) {
      case 'Obese':       return calories < 100;
      case 'Overweight':  return calories < 200;
      case 'Underweight': return calories > 150;
      case 'Normal':      
      default:            return true;
    }
  }

  static FoodItem _parse(Map<String, dynamic> food) {
    final nutrients = food['foodNutrients'] as List<dynamic>? ?? [];

    double get(int id) {
      try {
        final n = nutrients.firstWhere((n) => (n as Map)['nutrientId'] == id) as Map;
        return (n['value'] ?? 0).toDouble();
      } catch (_) {
        return 0.0;
      }
    }

    String cleanName(String raw) {
      final parts = raw.split(',');
      final shortName = parts.take(2).join(' ').trim();
      
      // 防止截断后变成完全空白
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
      tip:      _tip(get(1008)),
    );
  }

  static String _tip(double kcal) {
    if (kcal < 50)  return 'Very low calorie — great for weight loss.';
    if (kcal < 150) return 'Low calorie and nutritious.';
    if (kcal > 400) return 'Calorie-dense — good for gaining weight.';
    return 'Nutritious and suitable for your BMI category.';
  }

  // 同步本地备用数据
  static List<FoodItem> _fallback(String cat) {
    final data = {
      'Underweight': [
        FoodItem(name: 'Grilled Chicken Breast', calories: 165, protein: 31,  fat: 3.6, carbs: 0,   tip: 'High protein helps build muscle mass.'),
        FoodItem(name: 'Brown Rice',             calories: 216, protein: 5,   fat: 1.8, carbs: 45,  tip: 'Complex carbs give sustained energy.'),
        FoodItem(name: 'Whole Egg',              calories: 155, protein: 13,  fat: 11,  carbs: 1.1, tip: 'Complete protein source.'),
        FoodItem(name: 'Avocado',                calories: 160, protein: 2,   fat: 15,  carbs: 9,   tip: 'Healthy fats increase calorie intake.'),
        FoodItem(name: 'Peanut Butter',          calories: 588, protein: 25,  fat: 50,  carbs: 20,  tip: 'Calorie-dense and easy to add to meals.'),
      ],
      'Normal': [
        FoodItem(name: 'Oatmeal',           calories: 68,  protein: 2.4, fat: 1.4, carbs: 12,  tip: 'Keeps you full longer.'),
        FoodItem(name: 'Grilled Salmon',    calories: 208, protein: 20,  fat: 13,  carbs: 0,   tip: 'Rich in omega-3 for heart health.'),
        FoodItem(name: 'Banana',            calories: 89,  protein: 1.1, fat: 0.3, carbs: 23,  tip: 'Natural energy boost.'),
        FoodItem(name: 'Greek Yogurt',      calories: 59,  protein: 10,  fat: 0.4, carbs: 3.6, tip: 'High protein, good for gut health.'),
        FoodItem(name: 'Broccoli',          calories: 34,  protein: 2.8, fat: 0.4, carbs: 7,   tip: 'High in fibre and vitamins.'),
        FoodItem(name: 'Whole Wheat Bread', calories: 247, protein: 13,  fat: 3.4, carbs: 41,  tip: 'More fibre than white bread.'),
        FoodItem(name: 'Apple',             calories: 52,  protein: 0.3, fat: 0.2, carbs: 14,  tip: 'Low calorie snack rich in fibre.'),
        FoodItem(name: 'Tofu',              calories: 76,  protein: 8,   fat: 4.8, carbs: 1.9, tip: 'Plant-based protein, low in fat.'),
        ],
      'Overweight': [
        FoodItem(name: 'Steamed Broccoli', calories: 34, protein: 2.8, fat: 0.4, carbs: 7, tip: 'Low calorie.'),
        FoodItem(name: 'Grilled Chicken', calories: 165, protein: 31, fat: 3.6, carbs: 0, tip: 'Lean protein.'),
        FoodItem(name: 'Spinach', calories: 23, protein: 2.9, fat: 0.4, carbs: 3.6, tip: 'Very low calorie.'),
        FoodItem(name: 'Cucumber', calories: 16, protein: 0.7, fat: 0.1, carbs: 3.6, tip: 'Almost zero calories.'),
        FoodItem(name: 'Boiled Egg', calories: 78, protein: 6, fat: 5, carbs: 0.6, tip: 'Filling protein snack.'),
      ],
      'Obese': [
        FoodItem(name: 'Mixed Green Salad', calories: 20, protein: 1.5, fat: 0.3, carbs: 3, tip: 'Eat freely.'),
        FoodItem(name: 'Steamed Broccoli', calories: 34, protein: 2.8, fat: 0.4, carbs: 7, tip: 'Fill your plate.'),
        FoodItem(name: 'Skinless Chicken', calories: 110, protein: 23, fat: 1.2, carbs: 0, tip: 'Lowest fat protein.'),
        FoodItem(name: 'Celery', calories: 16, protein: 0.7, fat: 0.2, carbs: 3, tip: 'Almost no calories.'),
        FoodItem(name: 'Plain Greek Yogurt', calories: 59, protein: 10, fat: 0.4, carbs: 3.6, tip: 'High protein.'),
      ],
    };
    return data[cat] ?? data['Normal']!;
  }
}