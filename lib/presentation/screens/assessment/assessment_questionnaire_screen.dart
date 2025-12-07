import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';

class AssessmentQuestionnaireScreen extends StatelessWidget {
  const AssessmentQuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Assessment Questionnaire')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.blue),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Answer these questions to assess your foreclosure risk',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Financial Information', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildQuestionCard(
              'Monthly Income',
              'Enter your total monthly household income',
              Icons.attach_money,
            ),
            _buildQuestionCard(
              'Monthly Expenses',
              'Enter your total monthly expenses',
              Icons.receipt_long,
            ),
            _buildQuestionCard(
              'Amount Owed',
              'Total amount owed on your mortgage',
              Icons.account_balance,
            ),
            const SizedBox(height: 24),
            Text('Property Information', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildQuestionCard(
              'Property Value',
              'Estimated current value of your property',
              Icons.home,
            ),
            _buildQuestionCard(
              'Missed Payments',
              'Number of missed mortgage payments',
              Icons.calendar_month,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Submit questionnaire
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Calculate Risk Score'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: AppTypography.bodySmall),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter value',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
