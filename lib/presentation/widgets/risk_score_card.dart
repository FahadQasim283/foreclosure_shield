import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../data/models/risk_assessment.dart';

class RiskScoreCard extends StatelessWidget {
  final RiskAssessment assessment;

  const RiskScoreCard({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getRiskCategoryColor(assessment.riskCategory);

    return Container(
      decoration: AppWidgetStyles.elevatedCard,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Risk Assessment', style: AppTypography.h4),
                  const SizedBox(height: 4),
                  Text(
                    'Last updated: ${_formatDate(assessment.assessmentDate)}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  assessment.riskCategory,
                  style: AppTypography.badge.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 6),
                ),
                child: Center(
                  child: Text(
                    '${assessment.riskScore}',
                    style: AppTypography.riskScoreMedium.copyWith(color: color),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Foreclosure Risk Score', style: AppTypography.bodyMedium),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: assessment.riskScore / 100,
                      backgroundColor: AppColors.neutral200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                'Amount Owed',
                '\$${_formatCurrency(assessment.amountOwed ?? 0)}',
                Icons.attach_money,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _buildStat(
                'Missed Payments',
                '${assessment.missedPayments ?? 0}',
                Icons.calendar_today,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _buildStat(
                'Property Value',
                '\$${_formatCurrency(assessment.propertyValue ?? 0)}',
                Icons.home,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.h4),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.caption, textAlign: TextAlign.center),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
