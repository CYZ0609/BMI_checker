import 'package:flutter/material.dart';

class BmiGauge extends StatelessWidget {
  final double bmi;
  const BmiGauge({super.key, required this.bmi});

  Color get _color {
    if (bmi < 18.5) return Colors.blue.shade600;
    if (bmi < 25.0) return Colors.green.shade600;
    if (bmi < 30.0) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  String get _category {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  // BMI 范围 10 → 40，共 30 个单位
  // 位置 = (bmi - 10) / 30，限制在 0.0 ~ 1.0 之间
  double get _ratio => ((bmi - 10) / 30).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 大数字
        Text(
          bmi.toStringAsFixed(1),
          style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: _color),
        ),
        // 类别
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _category,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _color),
          ),
        ),

        const SizedBox(height: 28),

        // ── 颜色条 + 箭头 ─────────────────────────────────────────
        // LayoutBuilder 拿到颜色条的真实宽度，箭头才能准确定位
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth;

            // 颜色条4段的比例（按真实 BMI 区间）
            // 总范围 10~40 = 30 单位
            // 偏瘦 10~18.5 = 8.5 单位 → flex 85
            // 正常 18.5~25 = 6.5 单位 → flex 65
            // 超重 25~30   = 5.0 单位 → flex 50
            // 肥胖 30~40   = 10  单位 → flex 100
            final arrowLeft = (_ratio * barWidth).clamp(6.0, barWidth - 6.0);

            return Column(
              children: [
                // 箭头（在颜色条上方）
                Stack(
                  children: [
                    SizedBox(width: barWidth, height: 20),
                    Positioned(
                      left: arrowLeft - 8,
                      top: 0,
                      child: const Icon(
                        Icons.arrow_drop_down,
                        size: 24,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // 颜色条（比例对应真实 BMI 区间）
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: [
                      Flexible(flex: 85,  child: Container(height: 18, color: Colors.blue.shade400)),
                      Flexible(flex: 65,  child: Container(height: 18, color: Colors.green.shade500)),
                      Flexible(flex: 50,  child: Container(height: 18, color: Colors.orange.shade500)),
                      Flexible(flex: 100, child: Container(height: 18, color: Colors.red.shade400)),
                    ],
                  ),
                ),

                // 刻度标注
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Flexible(flex: 85,  child: Text('10',   style: TextStyle(fontSize: 10, color: Colors.grey))),
                    Flexible(flex: 65,  child: Text('18.5', style: TextStyle(fontSize: 10, color: Colors.grey))),
                    Flexible(flex: 50,  child: Text('25',   style: TextStyle(fontSize: 10, color: Colors.grey))),
                    Flexible(flex: 100, child: Text('30',   style: TextStyle(fontSize: 10, color: Colors.grey))),
                    SizedBox(width: 2),
                    Text('40+', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}