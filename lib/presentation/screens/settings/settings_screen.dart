import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/core/routes/route_names.dart';
import '/state/settings_provider.dart';
import '/state/auth_provider.dart';
import '/state/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await Future.wait([settingsProvider.getSettings(), userProvider.getUserProfile()]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<SettingsProvider, UserProvider, AuthProvider>(
      builder: (context, settingsProvider, userProvider, authProvider, child) {
        if (settingsProvider.isLoading && !settingsProvider.hasSettings) {
          return Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final user = userProvider.user;
        final settings = settingsProvider.settings;

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              children: [
                // Account Section
                _buildSectionHeader('Account'),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.name[0].toUpperCase() ?? 'U',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(user?.name ?? 'User', style: AppTypography.bodyLarge),
                  subtitle: Text(user?.email ?? '', style: AppTypography.bodySmall),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.editProfile),
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
                    '${user?.subscriptionType ?? "FREE"} Plan',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.secondary),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(RouteNames.subscription),
                ),
                const Divider(),

                // Notifications Section
                _buildSectionHeader('Notifications'),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active),
                  title: Text('Push Notifications', style: AppTypography.bodyLarge),
                  subtitle: Text('Receive alerts and reminders', style: AppTypography.bodySmall),
                  value: settings?.notifications.pushNotifications ?? true,
                  onChanged: (value) async {
                    if (settings?.notifications != null) {
                      // Create new preferences object with updated value
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Push notifications ${value ? "enabled" : "disabled"}'),
                        ),
                      );
                    }
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.email),
                  title: Text('Email Notifications', style: AppTypography.bodyLarge),
                  subtitle: Text('Weekly summaries and updates', style: AppTypography.bodySmall),
                  value: settings?.notifications.emailNotifications ?? true,
                  onChanged: (value) async {
                    if (settings?.notifications != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email notifications ${value ? "enabled" : "disabled"}'),
                        ),
                      );
                    }
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.alarm),
                  title: Text('Deadline Reminders', style: AppTypography.bodyLarge),
                  subtitle: Text(
                    'Get notified before important dates',
                    style: AppTypography.bodySmall,
                  ),
                  value: settings?.notifications.taskReminders ?? true,
                  onChanged: (value) async {
                    if (settings?.notifications != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task reminders ${value ? "enabled" : "disabled"}')),
                      );
                    }
                  },
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
                      _showLogoutDialog(context, authProvider);
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Log Out',
                      style: AppTypography.bodyLarge.copyWith(color: Colors.red),
                    ),
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
          ),
        );
      },
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

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (context.mounted) {
                context.go(RouteNames.login);
              }
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
