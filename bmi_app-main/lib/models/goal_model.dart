// 定义所有可选目标
// 这个 enum 在整个 app 里共用，不要改名字

enum UserGoal {
  loseWeight,
  buildMuscle,
  stayHealthy,
  improveStamina,
}

// 每个目标的显示文字、图标、描述
extension UserGoalExtension on UserGoal {
  String get label {
    switch (this) {
      case UserGoal.loseWeight:     return 'Lose Weight';
      case UserGoal.buildMuscle:    return 'Build Muscle';
      case UserGoal.stayHealthy:    return 'Stay Healthy';
      case UserGoal.improveStamina: return 'Improve Stamina';
    }
  }

  String get description {
    switch (this) {
      case UserGoal.loseWeight:     return 'Reduce body fat through diet and cardio';
      case UserGoal.buildMuscle:    return 'Gain muscle mass with strength training';
      case UserGoal.stayHealthy:    return 'Maintain a balanced and active lifestyle';
      case UserGoal.improveStamina: return 'Build endurance and cardiovascular fitness';
    }
  }

  String get emoji {
    switch (this) {
      case UserGoal.loseWeight:     return '🔥';
      case UserGoal.buildMuscle:    return '💪';
      case UserGoal.stayHealthy:    return '🌿';
      case UserGoal.improveStamina: return '🏃';
    }
  }

  // 存储用的字符串（存进 SharedPreferences）
  String get storageKey {
    switch (this) {
      case UserGoal.loseWeight:     return 'Lose Weight';
      case UserGoal.buildMuscle:    return 'Build Muscle';
      case UserGoal.stayHealthy:    return 'Stay Healthy';
      case UserGoal.improveStamina: return 'Improve Stamina';
    }
  }

  // 从字符串还原 enum
  static UserGoal? fromString(String s) {
    for (final g in UserGoal.values) {
      if (g.storageKey == s) return g;
    }
    return null;
  }
}