import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/root_scaffold.dart';

void main() {
  runApp(const AIHealthApp());
}

class AIHealthApp extends StatelessWidget {
  const AIHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI.Health',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const RootScaffold(),
    );
  }
}
