import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/theme.dart';

class StartAssessmentScreen extends StatelessWidget {
  const StartAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Assessment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Image/Icon
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Icon(Icons.assessment, size: 100, color: AppColors.secondary)),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Foreclosure Risk Assessment',
              style: AppTypography.display2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'Get a comprehensive analysis of your foreclosure situation with AI-powered recommendations.',
              style: AppTypography.bodyLarge.copyWith(color: AppColors.neutral600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Features List
            _buildFeatureItem(
              Icons.calculate,
              'Risk Score Calculation',
              'Numerical risk score from 0-100',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.trending_up,
              'Category Assessment',
              'CRITICAL, URGENT, AT-RISK classification',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.schedule,
              'Timeline Analysis',
              'Days to auction and key deadlines',
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.lightbulb_outline,
              'AI Action Plan',
              '30 and 60-day customized action plans',
            ),
            const SizedBox(height: 32),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blueLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Assessment takes 5-10 minutes. All information is confidential.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.blueDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Start Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.push(RouteNames.assessmentQuestionnaire);
                },
                child: Text('Start Assessment', style: AppTypography.buttonLarge),
              ),
            ),
            const SizedBox(height: 16),

            // View History Button
            SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  context.push(RouteNames.assessmentHistory);
                },
                child: Text(
                  'View Previous Assessments',
                  style: AppTypography.buttonMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
