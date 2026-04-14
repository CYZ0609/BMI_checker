import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/goal_model.dart';
import '../providers/bmi_provider.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentGoal = context.watch<BmiProvider>().goal;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Goal'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 8),

            // 顶部说明
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your health goal?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF085041),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your diet and exercise recommendations will be personalised based on your goal and BMI.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF0F6E56)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Select your goal:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // 4个目标选项
            ...UserGoal.values.map((goal) => _goalCard(context, goal, currentGoal)),

            const Spacer(),

            // 当前已选提示
            if (currentGoal != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Current goal: ${currentGoal.label}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _goalCard(BuildContext context, UserGoal goal, UserGoal? currentGoal) {
    final isSelected = currentGoal == goal;

    // 每个目标的颜色
    final colors = {
      UserGoal.loseWeight:     [const Color(0xFFFCEBEB), const Color(0xFFA32D2D), const Color(0xFFE24B4A)],
      UserGoal.buildMuscle:    [const Color(0xFFE6F1FB), const Color(0xFF0C447C), const Color(0xFF378ADD)],
      UserGoal.stayHealthy:    [const Color(0xFFEAF3DE), const Color(0xFF27500A), const Color(0xFF639922)],
      UserGoal.improveStamina: [const Color(0xFFFAEEDA), const Color(0xFF633806), const Color(0xFFBA7517)],
    };

    final bg     = isSelected ? colors[goal]![2].withOpacity(0.15) : Colors.white;
    final border = isSelected ? colors[goal]![2] : Colors.grey.shade200;
    final textColor = colors[goal]![1];

    return GestureDetector(
      onTap: () {
        context.read<BmiProvider>().setGoal(goal);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Goal set to: ${goal.label}'),
            duration: const Duration(seconds: 1),
            backgroundColor: colors[goal]![2],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: border,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // emoji 图标
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors[goal]![2].withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(goal.emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),

            const SizedBox(width: 14),

            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    goal.description,
                    style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),

            // 选中图标
            if (isSelected)
              Icon(Icons.check_circle, color: colors[goal]![2], size: 22),
          ],
        ),
      ),
    );
  }
}