import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/data/mock_data.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  bool _isAnnual = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription Plans')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Plan Badge
          if (MockData.mockUser.subscriptionType != 'FREE')
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium, color: AppColors.secondary, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan: ${MockData.mockUser.subscriptionType}',
                          style: AppTypography.h3.copyWith(color: AppColors.secondary),
                        ),
                        Text(
                          'Active until ${_formatDate(MockData.mockUser.subscriptionExpiryDate)}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Billing Toggle
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggleButton('Monthly', !_isAnnual),
                  _buildToggleButton('Annual (Save 20%)', _isAnnual),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Free Plan
          _buildPlanCard(
            title: 'FREE',
            price: '\$0',
            period: 'forever',
            description: 'Basic foreclosure prevention tools',
            features: [
              'Basic risk assessment',
              'Up to 3 action tasks',
              'Limited document templates',
              'Community support',
              'Educational resources',
            ],
            isCurrent: MockData.mockUser.subscriptionType == 'FREE',
            color: Colors.grey,
          ),
          const SizedBox(height: 16),

          // Basic Plan
          _buildPlanCard(
            title: 'BASIC',
            price: _isAnnual ? '\$19' : '\$24',
            period: _isAnnual ? 'per month (billed annually)' : 'per month',
            description: 'Enhanced tools for homeowners at risk',
            features: [
              'Everything in FREE, plus:',
              'Advanced risk assessment',
              'Unlimited action tasks',
              'All document templates',
              'Email support',
              'Priority notifications',
              'Document tracking',
            ],
            isCurrent: MockData.mockUser.subscriptionType == 'BASIC',
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),

          // Pro Plan (Most Popular)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary, width: 2),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '⭐ MOST POPULAR',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildPlanCard(
                  title: 'PRO',
                  price: _isAnnual ? '\$39' : '\$49',
                  period: _isAnnual ? 'per month (billed annually)' : 'per month',
                  description: 'AI-powered foreclosure defense',
                  features: [
                    'Everything in BASIC, plus:',
                    'AI-powered risk analysis',
                    'Automated document generation',
                    'Real-time deadline tracking',
                    'Personalized action plans',
                    'Phone support',
                    'Attorney directory access',
                    'Court filing assistance',
                    'Financial planning tools',
                  ],
                  isCurrent: MockData.mockUser.subscriptionType == 'PRO',
                  color: AppColors.secondary,
                  noBorder: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Premium Plan
          _buildPlanCard(
            title: 'PREMIUM',
            price: _isAnnual ? '\$79' : '\$99',
            period: _isAnnual ? 'per month (billed annually)' : 'per month',
            description: 'Complete foreclosure prevention suite',
            features: [
              'Everything in PRO, plus:',
              'Dedicated case manager',
              '24/7 priority support',
              'Attorney consultation (1hr/month)',
              'Credit repair guidance',
              'Loan modification assistance',
              'Court representation prep',
              'Unlimited AI generations',
              'Custom legal strategies',
            ],
            isCurrent: MockData.mockUser.subscriptionType == 'PREMIUM',
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 32),

          // FAQ Section
          Text('Frequently Asked Questions', style: AppTypography.h2),
          const SizedBox(height: 16),
          _buildFAQ(
            'Can I cancel anytime?',
            'Yes, you can cancel your subscription at any time. Your access will continue until the end of your billing period.',
          ),
          _buildFAQ(
            'What payment methods do you accept?',
            'We accept all major credit cards, debit cards, and PayPal.',
          ),
          _buildFAQ(
            'Do you offer refunds?',
            'We offer a 30-day money-back guarantee for all paid plans. No questions asked.',
          ),
          _buildFAQ(
            'Can I upgrade or downgrade my plan?',
            'Yes, you can change your plan at any time. Upgrades take effect immediately, downgrades at the end of your billing period.',
          ),
          const SizedBox(height: 24),

          // Contact Support
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.support_agent, size: 48, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  'Need help choosing a plan?',
                  style: AppTypography.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Our team is here to help you find the right solution',
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat),
                  label: const Text('Contact Support'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAnnual = label.contains('Annual');
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String period,
    required String description,
    required List<String> features,
    required bool isCurrent,
    required Color color,
    bool noBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(noBorder ? 0 : 16),
        border: noBorder ? null : Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h2.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CURRENT',
                    style: AppTypography.labelSmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: AppTypography.display2.copyWith(color: color)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(period, style: AppTypography.bodySmall),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    feature.startsWith('Everything') ? Icons.star : Icons.check_circle,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: feature.startsWith('Everything')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isCurrent ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent ? Colors.grey : color,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(isCurrent ? 'Current Plan' : 'Choose $title'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: AppTypography.bodyMedium),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.month}/${date.day}/${date.year}';
  }
}
