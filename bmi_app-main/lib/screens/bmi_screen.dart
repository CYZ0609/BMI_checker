import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bmi_provider.dart';
import 'result_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // 用来验证表单

  @override
  void dispose() {
    // 页面销毁时清理 controller，防止内存泄漏
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onCalculate() {
    // 检查所有 TextFormField 的 validator 是否都通过
    if (!_formKey.currentState!.validate()) return;

    final double height = double.parse(_heightController.text);
    final double weight = double.parse(_weightController.text);

    // 把数值传给 Provider，Provider 会算好 BMI 并通知所有页面
    // listen: false 因为我们只是"写入"，不需要监听变化
    context.read<BmiProvider>().calculateAndSet(height, weight);

    // 跳到结果页
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResultScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // 避免键盘弹起时内容被遮住
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // 顶部图示
              const Icon(Icons.monitor_weight_outlined, size: 72, color: Color(0xFF1D9E75)),
              const SizedBox(height: 8),
              const Text(
                'Enter your details',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 36),

              // 身高输入
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Height',
                  suffixText: 'cm',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your height';
                  final h = double.tryParse(value);
                  if (h == null || h < 50 || h > 250) return 'Enter a valid height (50–250 cm)';
                  return null; // null 表示验证通过
                },
              ),

              const SizedBox(height: 16),

              // 体重输入
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.line_weight),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your weight';
                  final w = double.tryParse(value);
                  if (w == null || w < 10 || w > 300) return 'Enter a valid weight (10–300 kg)';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // 计算按钮
              ElevatedButton(
                onPressed: _onCalculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9E75),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Calculate BMI', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}