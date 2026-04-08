// 这是一个纯数据类（Model）
// 定义"一条 BMI 记录"长什么样
// 所有人都可能用到这个文件，不要随便改

class BmiRecord {
  final double bmi;         // BMI 数值，例如 22.5
  final String category;    // 类别：Underweight / Normal / Overweight / Obese
  final DateTime date;      // 记录的时间（Student 4 的历史页会用）

  BmiRecord({
    required this.bmi,
    required this.category,
    required this.date,
  });

  // 把一条记录转成 String，方便存进 SharedPreferences
  // 格式："22.5|Normal|2024-01-15T10:30:00"
  String toStorageString() {
    return '$bmi|$category|${date.toIso8601String()}';
  }

  // 把 String 转回 BmiRecord（Student 4 读历史记录时用）
  factory BmiRecord.fromStorageString(String s) {
    final parts = s.split('|');
    return BmiRecord(
      bmi: double.parse(parts[0]),
      category: parts[1],
      date: DateTime.parse(parts[2]),
    );
  }
}