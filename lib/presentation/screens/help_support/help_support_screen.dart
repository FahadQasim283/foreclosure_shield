import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Support Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent, size: 60, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  'Need Immediate Assistance?',
                  style: AppTypography.h2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Our support team is here 24/7 to help you with your foreclosure concerns',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat),
                        label: const Text('Live Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone),
                        label: const Text('Call Us'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Contact Methods
          Text('Get in Touch', style: AppTypography.h2),
          const SizedBox(height: 16),
          _buildContactMethod(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'support@foreclosureshield.com',
            detail: 'Response within 24 hours',
            color: AppColors.primary,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildContactMethod(
            icon: Icons.phone,
            title: 'Phone Support',
            subtitle: '1-800-SHIELD-1',
            detail: 'Available 24/7',
            color: AppColors.secondary,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildContactMethod(
            icon: Icons.chat_bubble,
            title: 'Live Chat',
            subtitle: 'Instant messaging support',
            detail: 'Available 9 AM - 9 PM EST',
            color: Colors.green,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // FAQ Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Frequently Asked Questions', style: AppTypography.h2),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'What is foreclosure and how can I stop it?',
            'Foreclosure is a legal process where a lender takes possession of a property due to non-payment. Our app helps you understand your rights, assess your risk, and take action to prevent foreclosure through various strategies.',
          ),
          _buildFAQItem(
            'How accurate is the risk assessment?',
            'Our AI-powered risk assessment analyzes multiple factors including your financial situation, loan details, and timeline. While highly accurate, it should be used as a guide alongside professional legal advice.',
          ),
          _buildFAQItem(
            'Can the app help me communicate with my lender?',
            'Yes! We provide AI-generated hardship letters, loan modification requests, and other professional documents to help you effectively communicate with your lender.',
          ),
          _buildFAQItem(
            'What if I miss a deadline?',
            'The app sends reminders before critical deadlines. However, if you miss one, contact our support team immediately. We can help you understand your options and next steps.',
          ),
          _buildFAQItem(
            'Is my personal information secure?',
            'Absolutely. We use bank-level encryption and follow strict data protection protocols. Your information is never shared without your explicit consent.',
          ),
          const SizedBox(height: 24),

          // Resources Section
          Text('Helpful Resources', style: AppTypography.h2),
          const SizedBox(height: 16),
          _buildResourceCard(
            icon: Icons.article,
            title: 'Foreclosure Guide',
            description: 'Complete guide to understanding and preventing foreclosure',
            color: AppColors.primary,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            icon: Icons.video_library,
            title: 'Video Tutorials',
            description: 'Step-by-step videos on using the app and understanding your options',
            color: Colors.red,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            icon: Icons.gavel,
            title: 'Legal Resources',
            description: 'Know your rights and legal protections',
            color: Colors.deepPurple,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildResourceCard(
            icon: Icons.people,
            title: 'Community Forum',
            description: 'Connect with others facing similar challenges',
            color: Colors.teal,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Feedback Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.rate_review, size: 48, color: AppColors.secondary),
                const SizedBox(height: 12),
                Text(
                  'We Value Your Feedback',
                  style: AppTypography.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Help us improve Foreclosure Shield by sharing your experience',
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.star),
                        label: const Text('Rate App'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.feedback),
                        label: const Text('Send Feedback'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Report Bug
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bug_report, color: Colors.red),
            ),
            title: Text('Report a Bug', style: AppTypography.bodyLarge),
            subtitle: Text('Help us fix issues you encounter', style: AppTypography.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required String detail,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle, style: AppTypography.bodyMedium),
            const SizedBox(height: 2),
            Text(detail, style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        isThreeLine: true,
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: AppTypography.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
