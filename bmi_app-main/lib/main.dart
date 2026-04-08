import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/bmi_provider.dart';
import 'screens/bmi_screen.dart';
import 'screens/diet_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BmiProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D9E75)),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const BmiScreen(),
    const DietScreen(),
    const ExerciseScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Bila tabIndex dalam provider berubah, update _currentIndex
    // 当 provider 里的 tabIndex 变化时，自动切换 tab
    final providerIndex = context.watch<BmiProvider>().tabIndex;
    if (providerIndex != _currentIndex) {
      // addPostFrameCallback 确保不在 build 里直接 setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _currentIndex = providerIndex);
      });
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          // 同步回 provider，避免状态不一致
          context.read<BmiProvider>().switchTab(index);
        },
        selectedItemColor: const Color(0xFF1D9E75),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.monitor_weight), label: 'BMI'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant),     label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Exercise'),
          BottomNavigationBarItem(icon: Icon(Icons.history),        label: 'History'),
        ],
      ),
    );
  }
}