class FoodItem {
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final String tip; 

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.tip = '',
  });
}