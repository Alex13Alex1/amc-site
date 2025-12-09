import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI.Health', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'AI-assisted lab test insights\nOncology • Immunology • Preventive health',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall health index', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Color(0xFF2D7EFF),
                              Color(0xFF1DD1A1),
                              Color(0xFF2D7EFF),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '82',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Stable with mild risks.\nFocus on inflammation & metabolism in the next consult.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              // TODO: navigate to New report tab programmatically
            },
            child: const Text('Start new AI report'),
          ),
        ],
      ),
    );
  }
}
