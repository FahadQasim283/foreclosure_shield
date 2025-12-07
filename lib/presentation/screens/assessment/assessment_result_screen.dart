import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock_data.dart';

class AssessmentResultScreen extends StatelessWidget {
  const AssessmentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assessment = MockData.mockAssessment;
    final color = AppColors.getRiskCategoryColor(assessment.riskCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Risk Score Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text('Your Risk Score', style: AppTypography.h3.copyWith(color: AppColors.white)),
                  const SizedBox(height: 16),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${assessment.riskScore}',
                        style: AppTypography.riskScoreLarge.copyWith(color: color),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      assessment.riskCategory,
                      style: AppTypography.h3.copyWith(color: color),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Assessed on ${_formatDate(assessment.assessmentDate)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Summary Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Risk Summary', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppWidgetStyles.elevatedCard,
                    child: Text(
                      assessment.riskSummary ?? 'No summary available',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Key Statistics
                  Text('Key Statistics', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Days to Auction',
                          '${assessment.daysToAuction ?? "N/A"}',
                          Icons.event,
                          AppColors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Missed Payments',
                          '${assessment.missedPayments ?? "N/A"}',
                          Icons.payment,
                          AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Amount Owed',
                          '\$${_formatNumber(assessment.amountOwed ?? 0)}',
                          Icons.attach_money,
                          AppColors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Property Value',
                          '\$${_formatNumber(assessment.propertyValue ?? 0)}',
                          Icons.home,
                          AppColors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(RouteNames.actionPlan);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.list_alt),
                          const SizedBox(width: 8),
                          Text('View Action Plan', style: AppTypography.buttonLarge),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        context.push(RouteNames.generateLetter);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.article_outlined),
                          const SizedBox(width: 8),
                          Text(
                            'Generate Letters',
                            style: AppTypography.buttonMedium.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go(RouteNames.main);
                    },
                    child: Text(
                      'Return to Dashboard',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.h3.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }
}
