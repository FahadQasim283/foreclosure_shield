import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock_data.dart';
import '../../widgets/risk_score_card.dart';
import '../../widgets/countdown_timer_card.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/task_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assessment = MockData.mockAssessment;
    final user = MockData.mockUser;
    final tasks = MockData.mockTasks.where((t) => !t.isCompleted).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: AppTypography.bodySmall.copyWith(color: AppColors.white.withOpacity(0.9)),
            ),
            Text(user.name, style: AppTypography.h4.copyWith(color: AppColors.white)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  context.push(RouteNames.notifications);
                },
              ),
              if (MockData.getUnreadNotificationsCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${MockData.getUnreadNotificationsCount()}',
                      style: AppTypography.badge.copyWith(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Risk Score Card
            RiskScoreCard(assessment: assessment),
            const SizedBox(height: 16),

            // Countdown Timer
            if (assessment.auctionDate != null)
              CountdownTimerCard(auctionDate: assessment.auctionDate!),
            const SizedBox(height: 24),

            // Quick Actions
            Text('Quick Actions', style: AppTypography.h3),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.assessment_outlined,
                    title: 'New Assessment',
                    color: AppColors.primary,
                    onTap: () {
                      context.push(RouteNames.startAssessment);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.description_outlined,
                    title: 'View Action Plan',
                    color: AppColors.secondary,
                    onTap: () {
                      context.push(RouteNames.actionPlan);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.article_outlined,
                    title: 'Generate Letter',
                    color: AppColors.blue,
                    onTap: () {
                      context.push(RouteNames.generateLetter);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    icon: Icons.history,
                    title: 'View History',
                    color: AppColors.green,
                    onTap: () {
                      context.push(RouteNames.assessmentHistory);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Priority Tasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Priority Tasks', style: AppTypography.h3),
                TextButton(
                  onPressed: () {
                    context.push(RouteNames.actionPlan);
                  },
                  child: Text(
                    'View All',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (tasks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 64, color: AppColors.neutral300),
                      const SizedBox(height: 16),
                      Text(
                        'No pending tasks',
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.neutral500),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskListItem(
                    task: task,
                    onTap: () {
                      context.push('${RouteNames.taskDetails}/${task.id}');
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
