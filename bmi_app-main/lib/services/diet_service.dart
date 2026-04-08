import '../models/food_model.dart';

class DietService {

  static Future<List<FoodItem>> getRecommendations(String bmiCategory) async {
    // 模拟短暂加载，让 UI 的 loading 动画可以显示
    await Future.delayed(const Duration(milliseconds: 500));
    return _data[bmiCategory] ?? _data['Normal']!;
  }

  static final Map<String, List<FoodItem>> _data = {

    // ── 偏瘦：增加热量和蛋白质摄入 ──────────────────────────────
    'Underweight': [
      FoodItem(
        name: 'Grilled Chicken Breast',
        calories: 165, protein: 31, fat: 3.6, carbs: 0,
        tip: 'High protein helps build muscle mass.',
      ),
      FoodItem(
        name: 'Brown Rice',
        calories: 216, protein: 5, fat: 1.8, carbs: 45,
        tip: 'Complex carbs give you sustained energy.',
      ),
      FoodItem(
        name: 'Whole Egg',
        calories: 155, protein: 13, fat: 11, carbs: 1.1,
        tip: 'Eggs are a complete protein source.',
      ),
      FoodItem(
        name: 'Avocado',
        calories: 160, protein: 2, fat: 15, carbs: 9,
        tip: 'Healthy fats help increase calorie intake.',
      ),
      FoodItem(
        name: 'Peanut Butter',
        calories: 588, protein: 25, fat: 50, carbs: 20,
        tip: 'Calorie-dense and easy to add to meals.',
      ),
      FoodItem(
        name: 'Full-cream Milk',
        calories: 61, protein: 3.2, fat: 3.3, carbs: 4.8,
        tip: 'Easy way to add calories to your diet.',
      ),
      FoodItem(
        name: 'Sweet Potato',
        calories: 86, protein: 1.6, fat: 0.1, carbs: 20,
        tip: 'Nutritious carb source rich in vitamins.',
      ),
      FoodItem(
        name: 'Almonds',
        calories: 579, protein: 21, fat: 50, carbs: 22,
        tip: 'Healthy snack rich in calories and nutrients.',
      ),
    ],

    // ── 正常：均衡饮食，维持现状 ─────────────────────────────────
    'Normal': [
      FoodItem(
        name: 'Oatmeal',
        calories: 68, protein: 2.4, fat: 1.4, carbs: 12,
        tip: 'Great breakfast, keeps you full longer.',
      ),
      FoodItem(
        name: 'Grilled Salmon',
        calories: 208, protein: 20, fat: 13, carbs: 0,
        tip: 'Rich in omega-3 for heart health.',
      ),
      FoodItem(
        name: 'Banana',
        calories: 89, protein: 1.1, fat: 0.3, carbs: 23,
        tip: 'Natural energy boost before exercise.',
      ),
      FoodItem(
        name: 'Greek Yogurt',
        calories: 59, protein: 10, fat: 0.4, carbs: 3.6,
        tip: 'High protein, good for gut health.',
      ),
      FoodItem(
        name: 'Broccoli',
        calories: 34, protein: 2.8, fat: 0.4, carbs: 7,
        tip: 'High in fibre and vitamins C and K.',
      ),
      FoodItem(
        name: 'Whole Wheat Bread',
        calories: 247, protein: 13, fat: 3.4, carbs: 41,
        tip: 'More fibre than white bread.',
      ),
      FoodItem(
        name: 'Apple',
        calories: 52, protein: 0.3, fat: 0.2, carbs: 14,
        tip: 'Low calorie snack rich in fibre.',
      ),
      FoodItem(
        name: 'Tofu',
        calories: 76, protein: 8, fat: 4.8, carbs: 1.9,
        tip: 'Plant-based protein, low in fat.',
      ),
    ],

    // ── 超重：控制热量，增加纤维 ─────────────────────────────────
    'Overweight': [
      FoodItem(
        name: 'Steamed Broccoli',
        calories: 34, protein: 2.8, fat: 0.4, carbs: 7,
        tip: 'Low calorie, high fibre — fills you up.',
      ),
      FoodItem(
        name: 'Grilled Chicken Breast',
        calories: 165, protein: 31, fat: 3.6, carbs: 0,
        tip: 'Lean protein keeps you full without extra fat.',
      ),
      FoodItem(
        name: 'Spinach',
        calories: 23, protein: 2.9, fat: 0.4, carbs: 3.6,
        tip: 'Very low calorie, rich in iron and vitamins.',
      ),
      FoodItem(
        name: 'Cucumber',
        calories: 16, protein: 0.7, fat: 0.1, carbs: 3.6,
        tip: 'Almost zero calories, keeps you hydrated.',
      ),
      FoodItem(
        name: 'Boiled Egg',
        calories: 78, protein: 6, fat: 5, carbs: 0.6,
        tip: 'Filling protein snack, low in carbs.',
      ),
      FoodItem(
        name: 'Lentils',
        calories: 116, protein: 9, fat: 0.4, carbs: 20,
        tip: 'High fibre and protein — great for satiety.',
      ),
      FoodItem(
        name: 'Tomato',
        calories: 18, protein: 0.9, fat: 0.2, carbs: 3.9,
        tip: 'Low calorie, rich in antioxidants.',
      ),
      FoodItem(
        name: 'Steamed Fish',
        calories: 105, protein: 22, fat: 1.7, carbs: 0,
        tip: 'Lean protein with very little fat.',
      ),
    ],

    // ── 肥胖：严格低卡，高蔬菜摄入 ──────────────────────────────
    'Obese': [
      FoodItem(
        name: 'Mixed Green Salad',
        calories: 20, protein: 1.5, fat: 0.3, carbs: 3,
        tip: 'Very low calorie, eat as much as you like.',
      ),
      FoodItem(
        name: 'Steamed Broccoli',
        calories: 34, protein: 2.8, fat: 0.4, carbs: 7,
        tip: 'Fill your plate with this — very filling.',
      ),
      FoodItem(
        name: 'Skinless Chicken Breast',
        calories: 110, protein: 23, fat: 1.2, carbs: 0,
        tip: 'Lowest fat protein option available.',
      ),
      FoodItem(
        name: 'Celery',
        calories: 16, protein: 0.7, fat: 0.2, carbs: 3,
        tip: 'Almost no calories. Great for snacking.',
      ),
      FoodItem(
        name: 'Steamed Egg White',
        calories: 52, protein: 11, fat: 0.2, carbs: 0.7,
        tip: 'Pure protein, zero fat.',
      ),
      FoodItem(
        name: 'Cabbage',
        calories: 25, protein: 1.3, fat: 0.1, carbs: 6,
        tip: 'Very cheap, very low calorie, very filling.',
      ),
      FoodItem(
        name: 'Carrot',
        calories: 41, protein: 0.9, fat: 0.2, carbs: 10,
        tip: 'Sweet snack that is low in calories.',
      ),
      FoodItem(
        name: 'Plain Greek Yogurt',
        calories: 59, protein: 10, fat: 0.4, carbs: 3.6,
        tip: 'High protein, avoid flavoured versions.',
      ),
    ],
  };
}