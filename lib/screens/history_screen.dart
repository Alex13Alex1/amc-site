import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('History', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Your previous AI reports will appear here.',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Text(
                'No reports yet.\nCreate your first AI report on the “New report” tab.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
