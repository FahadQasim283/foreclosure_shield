import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/core/routes/route_names.dart';
import '/state/assessment_provider.dart';

class AssessmentHistoryScreen extends StatefulWidget {
  const AssessmentHistoryScreen({super.key});

  @override
  State<AssessmentHistoryScreen> createState() => _AssessmentHistoryScreenState();
}

class _AssessmentHistoryScreenState extends State<AssessmentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  Future<void> _loadHistory() async {
    final assessmentProvider = context.read<AssessmentProvider>();
    await assessmentProvider.getAssessmentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, assessmentProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Assessment History'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Implement filtering
                },
              ),
            ],
          ),
          body: _buildBody(assessmentProvider),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.push(RouteNames.startAssessment);
            },
            icon: const Icon(Icons.add),
            label: const Text('New Assessment'),
          ),
        );
      },
    );
  }

  Widget _buildBody(AssessmentProvider provider) {
    if (provider.isLoading && provider.assessmentHistory.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.hasError && provider.assessmentHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Failed to load history',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _loadHistory, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (provider.assessmentHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assessment, size: 80, color: AppColors.neutral300),
            const SizedBox(height: 16),
            Text(
              'No assessments yet',
              style: AppTypography.h4.copyWith(color: AppColors.neutral500),
            ),
            const SizedBox(height: 8),
            Text(
              'Start your first assessment',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral400),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.assessmentHistory.length,
        itemBuilder: (context, index) {
          final assessment = provider.assessmentHistory[index];
          return _buildHistoryCard(
            assessment: assessment,
            onTap: () {
              // Navigate to assessment result screen
              context.push(RouteNames.assessmentResult, extra: assessment);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard({required assessment, required VoidCallback onTap}) {
    final color = _getRiskColor(assessment.riskCategory);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                    Text(
                      assessment.riskScore.toString(),
                      style: AppTypography.display1.copyWith(color: color),
                    ),
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
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        assessment.riskCategory,
                        style: AppTypography.labelSmall.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_formatDate(assessment.assessmentDate), style: AppTypography.bodyMedium),
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
      ),
    );
  }

  Color _getRiskColor(String category) {
    switch (category.toUpperCase()) {
      case 'LOW':
      case 'SAFE':
        return AppColors.green;
      case 'MODERATE':
      case 'AT-RISK':
        return AppColors.amber;
      case 'HIGH':
      case 'URGENT':
        return AppColors.orange;
      case 'CRITICAL':
        return AppColors.red;
      default:
        return AppColors.neutral500;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
