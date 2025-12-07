import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/data/mock_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                MockData.mockUser.name[0].toUpperCase(),
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(MockData.mockUser.name, style: AppTypography.bodyLarge),
            subtitle: Text(MockData.mockUser.email, style: AppTypography.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to profile edit
            },
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.workspace_premium, color: AppColors.secondary),
            ),
            title: Text('Subscription Plan', style: AppTypography.bodyLarge),
            subtitle: Text(
              '${MockData.mockUser.subscriptionPlan} Plan',
              style: AppTypography.bodySmall.copyWith(color: AppColors.secondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to subscription
            },
          ),
          const Divider(),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: Text('Push Notifications', style: AppTypography.bodyLarge),
            subtitle: Text('Receive alerts and reminders', style: AppTypography.bodySmall),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email),
            title: Text('Email Notifications', style: AppTypography.bodyLarge),
            subtitle: Text('Weekly summaries and updates', style: AppTypography.bodySmall),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.alarm),
            title: Text('Deadline Reminders', style: AppTypography.bodyLarge),
            subtitle: Text('Get notified before important dates', style: AppTypography.bodySmall),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),

          // Privacy & Security Section
          _buildSectionHeader('Privacy & Security'),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text('Change Password', style: AppTypography.bodyLarge),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text('Two-Factor Authentication', style: AppTypography.bodyLarge),
            subtitle: Text(
              'Enabled',
              style: AppTypography.bodySmall.copyWith(color: AppColors.green),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: Text('Biometric Login', style: AppTypography.bodyLarge),
            trailing: Switch(value: false, onChanged: (value) {}),
          ),
          const Divider(),

          // Data & Storage Section
          _buildSectionHeader('Data & Storage'),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text('Download My Data', style: AppTypography.bodyLarge),
            subtitle: Text('Export all your information', style: AppTypography.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text('Clear Cache', style: AppTypography.bodyLarge),
            subtitle: Text('Free up storage space', style: AppTypography.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // Support Section
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text('Help Center', style: AppTypography.bodyLarge),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: Text('Contact Support', style: AppTypography.bodyLarge),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: Text('Report a Bug', style: AppTypography.bodyLarge),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('About Foreclosure Shield', style: AppTypography.bodyLarge),
            subtitle: Text('Version 1.0.0', style: AppTypography.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text('Terms of Service', style: AppTypography.bodyLarge),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text('Privacy Policy', style: AppTypography.bodyLarge),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),

          // Danger Zone
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text('Log Out', style: AppTypography.bodyLarge.copyWith(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton.icon(
              onPressed: () {
                _showDeleteAccountDialog(context);
              },
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: Text(
                'Delete Account',
                style: AppTypography.bodySmall.copyWith(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.neutral600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be deleted.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
