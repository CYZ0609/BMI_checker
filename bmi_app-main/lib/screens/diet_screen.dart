import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal_model.dart'; 
import '../providers/bmi_provider.dart';
import '../models/food_model.dart';
import '../services/diet_service.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  late Future<List<FoodItem>> _future;
  String? _lastCategory;
  UserGoal? _lastGoal; // 1. 新增：记录上一次的目标

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final provider = context.read<BmiProvider>();
    final cat  = provider.currentCategory ?? 'Normal';
    final goal = provider.goal;
    
    _lastCategory = cat;
    _lastGoal = goal; // 2. 新增：每次加载时保存当前目标
    
    _future = DietService.getRecommendations(cat, goal: goal); 
  }

  Map<String, dynamic> _info(String? cat) {
    switch (cat) {
      case 'Underweight':
        return {
          'color':   Colors.blue.shade700,
          'bg':      Colors.blue.shade50,
          'icon':    Icons.trending_up,
          'title':   'You are Underweight (BMI below 18.5)',
          'advice':  'You need to eat MORE. Focus on high-calorie and high-protein foods to gain weight in a healthy way.',
        };
      case 'Normal':
        return {
          'color':   Colors.green.shade700,
          'bg':      Colors.green.shade50,
          'icon':    Icons.check_circle_outline,
          'title':   'You are at Normal weight (BMI 18.5 – 24.9)',
          'advice':  'Great! Keep eating balanced meals with variety from all food groups to maintain your healthy weight.',
        };
      case 'Overweight':
        return {
          'color':   Colors.orange.shade700,
          'bg':      Colors.orange.shade50,
          'icon':    Icons.trending_down,
          'title':   'You are Overweight (BMI 25 – 29.9)',
          'advice':  'You need to eat LESS. Choose low-calorie, high-fibre foods. Avoid fried food, sugary drinks, and processed food.',
        };
      case 'Obese':
        return {
          'color':   Colors.red.shade700,
          'bg':      Colors.red.shade50,
          'icon':    Icons.warning_amber_outlined,
          'title':   'You are Obese (BMI 30 and above)',
          'advice':  'Strict diet is needed. Eat mostly vegetables and lean protein. Avoid all high-calorie food. Consider seeing a nutritionist.',
        };
      default:
        return {
          'color':   Colors.grey.shade600,
          'bg':      Colors.grey.shade100,
          'icon':    Icons.info_outline,
          'title':   'No BMI data yet',
          'advice':  'Go to the BMI tab, enter your height and weight, then come back here.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final cat = context.watch<BmiProvider>().currentCategory;
    final goal = context.watch<BmiProvider>().goal; // 获取当前目标

    // 3. 只要 BMI 变了，或者目标变了，就强制重新加载！
    if ((cat != null && cat != _lastCategory) || (goal != _lastGoal)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(_load));
    }

    final info = _info(cat);
    final color = info['color'] as Color;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Diet Recommendations'),
        centerTitle: true,
        backgroundColor: const Color(0xFFBA7517),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            color: info['bg'] as Color,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(info['icon'] as IconData, color: color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(info['title'] as String,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                      const SizedBox(height: 6),
                      Text(info['advice'] as String,
                        style: TextStyle(fontSize: 13, color: color, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 新增的 Goal 显示模块，放在顶部横幅下面
          if (context.watch<BmiProvider>().goal != null)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  Text(
                    context.watch<BmiProvider>().goal!.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Goal: ${context.watch<BmiProvider>().goal!.label}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              cat != null
                ? 'Recommended foods for "$cat" BMI:'
                : 'Showing default recommendations:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<FoodItem>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final foods = snap.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: foods.length,
                  itemBuilder: (ctx, i) => _foodCard(foods[i], color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodCard(FoodItem food, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 食物名称
            Row(
              children: [
                const Icon(Icons.restaurant_menu, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(food.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ],
            ),

            if (food.tip.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 14, color: color),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(food.tip,
                        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 16),

            // 营养数值（per 100g）
            Row(
              children: [
                _nutrient('Calories',  '${food.calories.toStringAsFixed(0)} kcal', Colors.orange),
                _nutrient('Protein',   '${food.protein.toStringAsFixed(1)} g',     Colors.blue),
                _nutrient('Carbs',     '${food.carbs.toStringAsFixed(1)} g',       Colors.green),
                _nutrient('Fat',       '${food.fat.toStringAsFixed(1)} g',         Colors.red),
              ],
            ),
            const SizedBox(height: 4),
            Text('per 100g',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  Widget _nutrient(String label, String value, MaterialColor c) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: c.shade700)),
          Text(label,  style: TextStyle(fontSize: 10, color: c.shade400)),
        ],
      ),
    );
  }
}