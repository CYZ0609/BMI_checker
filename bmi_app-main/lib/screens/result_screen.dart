import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bmi_provider.dart';
import '../services/storage_service.dart';
import '../widgets/bmi_gauge.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _saveRecord();
  }

  Future<void> _saveRecord() async {
    if (_saved) return;
    final record = context.read<BmiProvider>().currentRecord;
    if (record != null) {
      await StorageService.saveRecord(record);
      _saved = true;
    }
  }

  void _goToTab(int index) {
    context.read<BmiProvider>().switchTab(index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final record = context.read<BmiProvider>().currentRecord;

    if (record == null) {
      return const Scaffold(body: Center(child: Text('No data found.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Result'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            BmiGauge(bmi: record.bmi),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'Get your personalised recommendations:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Diet → index 2（因为 Goal tab 插在 index 1）
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _goToTab(2),
                icon: const Icon(Icons.restaurant),
                label: const Text('View Diet Recommendations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA7517),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Exercise → index 3
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _goToTab(3),
                icon: const Icon(Icons.fitness_center),
                label: const Text('View Exercise Recommendations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF534AB7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // History → index 4
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _goToTab(4),
                icon: const Icon(Icons.history),
                label: const Text('View History'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}