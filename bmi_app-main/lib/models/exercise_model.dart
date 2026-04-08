// 定义"一条运动推荐"的数据结构
class ExerciseItem {
  final String name;         // 运动名称，例如 "Push Up"
  final String category;     // 运动分类，例如 "Chest", "Legs"
  final String description;  // 动作说明
  final int sets;            // 建议组数
  final int reps;            // 建议次数 / 时间（秒）
  final String unit;         // 'reps' 或 'seconds'

  ExerciseItem({
    required this.name,
    required this.category,
    required this.description,
    required this.sets,
    required this.reps,
    required this.unit,
  });

  // 显示用的字符串，例如 "3 sets × 12 reps"
  String get setsRepsLabel => '$sets sets × $reps $unit';
}