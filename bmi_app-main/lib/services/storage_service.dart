import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_model.dart';

class StorageService {

  // SharedPreferences 里存数据的 key
  // 就像字典的"键"，用来找到对应的值
  static const String _historyKey = 'bmi_history';

  // ── 存入一条 BMI 记录 ────────────────────────────────────────
  static Future<void> saveRecord(BmiRecord record) async {
    // SharedPreferences 是手机本地存储
    // 类似 Python 的字典，但数据存在手机里，关掉 app 也不会消失
    final prefs = await SharedPreferences.getInstance();

    // 先把已有的记录全部读出来
    final existing = prefs.getStringList(_historyKey) ?? [];

    // 把新记录转成 String 加进去
    // 格式："22.5|Normal|2024-01-15T10:30:00"
    existing.add(record.toStorageString());

    // 只保留最近 30 条，防止数据太多
    final trimmed = existing.length > 30
        ? existing.sublist(existing.length - 30)
        : existing;

    // 存回去
    await prefs.setStringList(_historyKey, trimmed);
  }

  // ── 读取所有历史记录 ─────────────────────────────────────────
  static Future<List<BmiRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_historyKey) ?? [];

    // 把每条 String 转回 BmiRecord
    // 用 whereType 过滤掉解析失败的数据（防御性编程）
    return stored
        .map((s) {
          try {
            return BmiRecord.fromStorageString(s);
          } catch (_) {
            return null; // 解析失败就跳过
          }
        })
        .whereType<BmiRecord>() // 过滤掉 null
        .toList()
        .reversed      // 最新的排在最前面
        .toList();
  }

  // ── 清空所有记录 ─────────────────────────────────────────────
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  // ── 计算统计数据 ─────────────────────────────────────────────
  // 供历史页显示"平均 BMI"等数据用
  static Map<String, double> getStats(List<BmiRecord> records) {
    if (records.isEmpty) return {'avg': 0, 'min': 0, 'max': 0};

    final bmis = records.map((r) => r.bmi).toList();
    final avg = bmis.reduce((a, b) => a + b) / bmis.length;
    final min = bmis.reduce((a, b) => a < b ? a : b);
    final max = bmis.reduce((a, b) => a > b ? a : b);

    return {'avg': avg, 'min': min, 'max': max};
  }
}