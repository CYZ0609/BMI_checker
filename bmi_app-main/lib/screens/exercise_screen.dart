import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bmi_provider.dart';
import '../models/exercise_model.dart';
import '../services/exercise_service.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late Future<List<ExerciseItem>> _future;
  String? _lastCategory;

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
  _future = ExerciseService.getRecommendations(cat, goal: goal);
}

  Map<String, dynamic> _info(String? cat) {
    switch (cat) {
      case 'Underweight':
        return {
          'color':  Colors.blue.shade700,
          'bg':     Colors.blue.shade50,
          'icon':   Icons.fitness_center,
          'title':  'You are Underweight (BMI below 18.5)',
          'advice': 'Focus on strength training to build muscle. Use heavier weights with fewer reps. Rest well between sessions.',
        };
      case 'Normal':
        return {
          'color':  Colors.green.shade700,
          'bg':     Colors.green.shade50,
          'icon':   Icons.self_improvement,
          'title':  'You are at Normal weight (BMI 18.5 – 24.9)',
          'advice': 'Mix strength and cardio to stay fit. Aim for at least 3 sessions per week.',
        };
      case 'Overweight':
        return {
          'color':  Colors.orange.shade700,
          'bg':     Colors.orange.shade50,
          'icon':   Icons.directions_run,
          'title':  'You are Overweight (BMI 25 – 29.9)',
          'advice': 'Focus on burning calories. Do more reps with shorter rest time. Add walking or jogging on rest days.',
        };
      case 'Obese':
        return {
          'color':  Colors.red.shade700,
          'bg':     Colors.red.shade50,
          'icon':   Icons.accessibility_new,
          'title':  'You are Obese (BMI 30 and above)',
          'advice': 'Start with low-impact exercises. Do not push too hard — be consistent and build up slowly. See a doctor if needed.',
        };
      default:
        return {
          'color':  Colors.grey.shade600,
          'bg':     Colors.grey.shade100,
          'icon':   Icons.help_outline,
          'title':  'No BMI data yet',
          'advice': 'Go to the BMI tab, enter your height and weight, then come back here.',
        };
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Chest':   return Icons.sports_gymnastics;
      case 'Legs':    return Icons.directions_walk;
      case 'Core':    return Icons.radio_button_unchecked;
      case 'Back':    return Icons.accessibility;
      case 'Arms':    return Icons.sports_handball;
      case 'Cardio':  return Icons.directions_run;
      default:        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cat = context.watch<BmiProvider>().currentCategory;

    if (cat != null && cat != _lastCategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(_load));
    }

    final info = _info(cat);
    final color = info['color'] as Color;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Exercise Recommendations'),
        centerTitle: true,
        backgroundColor: const Color(0xFF534AB7),
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

          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              cat != null
                ? 'Exercises recommended for "$cat" BMI:'
                : 'Showing default exercises:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<ExerciseItem>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snap.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => _exerciseCard(list[i], color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseCard(ExerciseItem ex, Color color) {
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

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_categoryIcon(ex.category), color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ex.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      Text(ex.category,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${ex.sets}×${ex.reps}\n${ex.unit}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                'How to do it:  ${ex.description}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}