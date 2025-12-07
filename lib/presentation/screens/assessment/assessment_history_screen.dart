import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';

class AssessmentHistoryScreen extends StatelessWidget {
  const AssessmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment History'),
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHistoryCard(
            date: 'December 2, 2025',
            score: 75,
            category: 'URGENT',
            color: AppColors.orange,
          ),
          _buildHistoryCard(
            date: 'November 15, 2025',
            score: 82,
            category: 'CRITICAL',
            color: AppColors.red,
          ),
          _buildHistoryCard(
            date: 'November 1, 2025',
            score: 65,
            category: 'URGENT',
            color: AppColors.orange,
          ),
          _buildHistoryCard(
            date: 'October 20, 2025',
            score: 58,
            category: 'AT-RISK',
            color: AppColors.amber,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Start new assessment
        },
        icon: const Icon(Icons.add),
        label: const Text('New Assessment'),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String date,
    required int score,
    required String category,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(score.toString(), style: AppTypography.display1.copyWith(color: color)),
                  Text('/100', style: AppTypography.bodySmall.copyWith(color: color)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      category,
                      style: AppTypography.labelSmall.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(date, style: AppTypography.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to view details',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
