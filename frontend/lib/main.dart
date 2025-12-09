import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/detailed_report_screen.dart';

void main() {
  runApp(const MedicinalApp());
}

class MedicinalApp extends StatelessWidget {
  const MedicinalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEDICINAL AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/report': (context) => const DetailedReportScreen(),
      },
    );
  }
}
