
class BmiRecord {
  final double bmi;
  final String category;
  final DateTime date;
  final String? goal; // 新增：记录当时的目标（可为空，兼容旧记录）

  BmiRecord({
    required this.bmi,
    required this.category,
    required this.date,
    this.goal,
  });

  // 存储格式：22.5|Normal|2024-01-15T10:30:00|Lose Weight
  // 旧格式没有第4段，读取时兼容处理
  String toStorageString() {
    final goalStr = goal ?? '';
    return '$bmi|$category|${date.toIso8601String()}|$goalStr';
  }

  factory BmiRecord.fromStorageString(String s) {
    final parts = s.split('|');
    return BmiRecord(
      bmi:      double.parse(parts[0]),
      category: parts[1],
      date:     DateTime.parse(parts[2]),
      goal:     parts.length > 3 && parts[3].isNotEmpty ? parts[3] : null,
    );
  }
}