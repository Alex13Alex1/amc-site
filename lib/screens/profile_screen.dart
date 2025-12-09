import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Profile & Data Wallet', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Manage your account, privacy and encrypted data wallet.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Privacy policy'),
          ),
          const ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('Terms of use'),
          ),
          const ListTile(
            leading: Icon(Icons.delete_forever_outlined),
            title: Text('Delete all local data'),
          ),
        ],
      ),
    );
  }
}
