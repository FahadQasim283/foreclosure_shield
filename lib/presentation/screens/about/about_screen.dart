import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Foreclosure Shield')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.shield, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text('Foreclosure Shield', style: AppTypography.h1),
                  const SizedBox(height: 8),
                  Text('Version 1.0.0', style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('About Us', style: AppTypography.h2),
            const SizedBox(height: 12),
            Text(
              'Foreclosure Shield is an AI-powered platform designed to help homeowners prevent foreclosure and protect their homes. Our mission is to provide accessible, affordable legal and financial tools to those facing housing challenges.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text('Key Features', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildFeatureItem('AI-Powered Risk Assessment', Icons.analytics),
            _buildFeatureItem('Automated Document Generation', Icons.description),
            _buildFeatureItem('Personalized Action Plans', Icons.assignment),
            _buildFeatureItem('Deadline Tracking', Icons.schedule),
            _buildFeatureItem('24/7 Support', Icons.support_agent),
            const SizedBox(height: 24),
            Text('Contact Information', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildContactItem(Icons.email, 'Email', 'fahadqasim3310@gmail.com'),
            _buildContactItem(Icons.phone, 'Phone', '+923021826959'),
            _buildContactItem(Icons.language, 'Website', 'www.foreclosureshield.com'),
            const SizedBox(height: 24),
            Text('Legal', style: AppTypography.h2),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: const Text('Legal Disclaimer'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '© 2025 Foreclosure Shield. All rights reserved.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600)),
                Text(value, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
