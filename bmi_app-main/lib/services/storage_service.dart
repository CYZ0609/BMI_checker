import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_model.dart';

class StorageService {

  static const String _historyKey = 'bmi_history';

  static Future<void> saveRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getStringList(_historyKey) ?? [];

    existing.add(record.toStorageString());

    final trimmed = existing.length > 30
        ? existing.sublist(existing.length - 30)
        : existing;

    await prefs.setStringList(_historyKey, trimmed);
  }

  static Future<List<BmiRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_historyKey) ?? [];

    return stored
        .map((s) {
          try {
            return BmiRecord.fromStorageString(s);
          } catch (_) {
            return null; 
          }
        })
        .whereType<BmiRecord>() 
        .toList()
        .reversed     
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  static Map<String, double> getStats(List<BmiRecord> records) {
    if (records.isEmpty) return {'avg': 0, 'min': 0, 'max': 0};

    final bmis = records.map((r) => r.bmi).toList();
    final avg = bmis.reduce((a, b) => a + b) / bmis.length;
    final min = bmis.reduce((a, b) => a < b ? a : b);
    final max = bmis.reduce((a, b) => a > b ? a : b);

    return {'avg': avg, 'min': min, 'max': max};
  }
}