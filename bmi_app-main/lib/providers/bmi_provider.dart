import 'package:flutter/material.dart';
import '../models/bmi_model.dart';
import '../models/goal_model.dart';

class BmiProvider extends ChangeNotifier {
  BmiRecord? _currentRecord;
  int        _tabIndex = 0;
  UserGoal?  _goal;           // 当前用户目标

  BmiRecord? get currentRecord   => _currentRecord;
  double?    get currentBmi      => _currentRecord?.bmi;
  String?    get currentCategory => _currentRecord?.category;
  int        get tabIndex        => _tabIndex;
  UserGoal?  get goal            => _goal;

  // 设置目标（在 GoalScreen 里调用）
  void setGoal(UserGoal goal) {
    _goal = goal;
    notifyListeners();
  }

  // 计算 BMI（同时把当前目标一起存进记录）
  void calculateAndSet(double heightCm, double weightKg) {
    final double heightM = heightCm / 100;
    final double bmi     = weightKg / (heightM * heightM);

    _currentRecord = BmiRecord(
      bmi:      bmi,
      category: _getCategory(bmi),
      date:     DateTime.now(),
      goal:     _goal?.storageKey, // 把目标一起存进记录
    );
    notifyListeners();
  }

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