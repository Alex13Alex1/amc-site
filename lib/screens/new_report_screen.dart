import 'package:flutter/material.dart';

class NewReportScreen extends StatelessWidget {
  const NewReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('New report', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to add your medical data.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _ActionCard(
            icon: Icons.picture_as_pdf_outlined,
            title: 'Upload PDF or images',
            subtitle: 'Blood tests, cardiograms, imaging reports',
            onTap: () {
              // TODO: open upload flow
            },
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.edit_note_outlined,
            title: 'Enter values manually',
            subtitle: 'Type in lab values and units',
            onTap: () {
              // TODO: open manual entry
            },
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.watch_outlined,
            title: 'Connect wearable',
            subtitle: 'Oura, Garmin, Fitbit and more',
            onTap: () {
              // TODO: wearable connect
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
