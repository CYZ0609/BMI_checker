import 'package:flutter/material.dart';
import '../models/bmi_model.dart';

class BmiProvider extends ChangeNotifier {
  BmiRecord? _currentRecord;
  int _tabIndex = 0; // 新增：控制底部导航栏

  BmiRecord? get currentRecord => _currentRecord;
  double?    get currentBmi      => _currentRecord?.bmi;
  String?    get currentCategory => _currentRecord?.category;
  int        get tabIndex        => _tabIndex;

  // 计算 BMI
  void calculateAndSet(double heightCm, double weightKg) {
    final double heightM = heightCm / 100;
    final double bmi     = weightKg / (heightM * heightM);

    _currentRecord = BmiRecord(
      bmi:      bmi,
      category: _getCategory(bmi),
      date:     DateTime.now(),
    );
    notifyListeners();
  }

  // 切换底部导航 tab（result_screen 的按钮会用到这个）
  void switchTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  String _getCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }
}