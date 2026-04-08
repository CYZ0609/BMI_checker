import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bmi_model.dart';
import '../providers/bmi_provider.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<BmiRecord> _records = [];
  bool _loading = true;

  // 记住上一次看到的 BMI 记录
  // 当 provider 里的 currentRecord 变了，就知道有新数据，马上刷新
  BmiRecord? _lastSeenRecord;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    final records = await StorageService.getHistory();
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue.shade600;
    if (bmi < 25.0) return Colors.green.shade600;
    if (bmi < 30.0) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  Color _bmiBgColor(double bmi) {
    if (bmi < 18.5) return Colors.blue.shade50;
    if (bmi < 25.0) return Colors.green.shade50;
    if (bmi < 30.0) return Colors.orange.shade50;
    return Colors.red.shade50;
  }

  String _formatDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}  $h:$m';
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all history?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await StorageService.clearHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── 关键修复：监听 provider，有新 BMI 就马上刷新历史 ──────────
    final currentRecord = context.watch<BmiProvider>().currentRecord;
    if (currentRecord != null && currentRecord != _lastSeenRecord) {
      _lastSeenRecord = currentRecord;
      // addPostFrameCallback 避免在 build 里直接调用 setState
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('BMI History'),
        centerTitle: true,
        backgroundColor: const Color(0xFF993C1D),
        foregroundColor: Colors.white,
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmClear,
              tooltip: 'Clear all',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      _buildStats(),
                      const SizedBox(height: 16),
                      _buildChart(),
                      const SizedBox(height: 16),
                      const Text('All records',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ..._records.map(_buildRecordCard),
                    ],
                  ),
                ),
    );
  }

  // ── 空状态 ───────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No records yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Go to the BMI tab and calculate your BMI',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  // ── 三格统计卡 ───────────────────────────────────────────────
  Widget _buildStats() {
    final stats = StorageService.getStats(_records);
    return Row(
      children: [
        _statCard('Average', stats['avg']!, Colors.purple.shade50, Colors.purple.shade700),
        const SizedBox(width: 8),
        _statCard('Lowest',  stats['min']!, Colors.green.shade50,  Colors.green.shade700),
        const SizedBox(width: 8),
        _statCard('Highest', stats['max']!, Colors.red.shade50,    Colors.red.shade700),
      ],
    );
  }

  Widget _statCard(String label, double value, Color bg, Color fg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: fg)),
            const SizedBox(height: 4),
            Text(value.toStringAsFixed(1),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: fg)),
            Text('BMI', style: TextStyle(fontSize: 10, color: fg.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  // ── 趋势柱状图 ───────────────────────────────────────────────
  Widget _buildChart() {
    final recent = _records.take(10).toList().reversed.toList();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent trend',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: recent.map((r) {
                final ratio = ((r.bmi - 10) / 30).clamp(0.0, 1.0);
                final barH = 16.0 + ratio * 60.0;
                final isLatest = r == recent.last;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isLatest)
                          Text(r.bmi.toStringAsFixed(1),
                            style: TextStyle(fontSize: 9, color: _bmiColor(r.bmi))),
                        const SizedBox(height: 2),
                        Container(
                          height: barH,
                          decoration: BoxDecoration(
                            color: _bmiColor(r.bmi),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Oldest', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
              Text('Latest', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
            ],
          ),
        ],
      ),
    );
  }

  // ── 每条记录 ─────────────────────────────────────────────────
  Widget _buildRecordCard(BmiRecord record) {
    final color = _bmiColor(record.bmi);
    final bg    = _bmiBgColor(record.bmi);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // BMI 数字圆圈
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(record.bmi.toStringAsFixed(1),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                  Text('BMI', style: TextStyle(fontSize: 9, color: color)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // 类别 + 时间
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.category,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
                  const SizedBox(height: 3),
                  Text(_formatDate(record.date),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}