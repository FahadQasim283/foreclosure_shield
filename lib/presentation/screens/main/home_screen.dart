import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../state/dashboard_provider.dart';
import '../../../state/user_provider.dart';
import '../../../state/notification_provider.dart';
import '../../widgets/risk_score_card.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/task_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final dashboardProvider = context.read<DashboardProvider>();
    final userProvider = context.read<UserProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    await Future.wait([
      dashboardProvider.getDashboardSummary(),
      userProvider.getUserProfile(),
      notificationProvider.getUnreadCount(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final userProvider = context.watch<UserProvider>();
    final notificationProvider = context.watch<NotificationProvider>();

    // Show loading indicator
    if (dashboardProvider.isLoading && dashboardProvider.summary == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show error if failed to load
    if (dashboardProvider.hasError && dashboardProvider.summary == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.red),
              const SizedBox(height: 16),
              Text('Failed to load dashboard', style: AppTypography.h3),
              const SizedBox(height: 8),
              Text(
                dashboardProvider.errorMessage ?? 'Unknown error',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final summary = dashboardProvider.summary;
    final user = userProvider.user;
    // Get tasks from action plan provider instead
    final tasks = <dynamic>[];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: AppTypography.bodySmall.copyWith(color: AppColors.white.withOpacity(0.9)),
            ),
            Text(user?.name ?? 'User', style: AppTypography.h4.copyWith(color: AppColors.white)),
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
              if (notificationProvider.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${notificationProvider.unreadCount}',
                      style: AppTypography.badge.copyWith(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Risk Score Card
              if (summary != null)
                RiskScoreCard(
                  riskScore: summary.riskSummary.riskScore.toInt(),
                  riskLevel: summary.riskSummary.currentRiskLevel,
                ),
              const SizedBox(height: 16),

              // Quick Actions Section
              const SizedBox(height: 8),

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
                ...tasks
                    .take(3)
                    .map(
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
      ),
    );
  }
}
