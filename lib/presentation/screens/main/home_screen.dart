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
              if (summary?.nextTask == null)
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
                _buildNextTaskCard(summary!.nextTask!, context),

              const SizedBox(height: 24),

              // Recent Documents
              if (summary != null && summary.recentDocuments.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Documents', style: AppTypography.h3),
                    TextButton(
                      onPressed: () {
                        context.push(RouteNames.documents);
                      },
                      child: Text(
                        'View All',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...summary.recentDocuments.take(3).map((doc) => _buildDocumentCard(doc, context)),
                const SizedBox(height: 24),
              ],

              // Recent Activities
              if (summary != null && summary.recentActivities.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Activities', style: AppTypography.h3),
                    TextButton(
                      onPressed: () {
                        context.push(RouteNames.notifications);
                      },
                      child: Text(
                        'View All',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...summary.recentActivities
                    .take(3)
                    .map((activity) => _buildActivityCard(activity, context)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextTaskCard(dynamic nextTask, BuildContext context) {
    final priorityColor = _getPriorityColor(nextTask.priority);
    final dueDate = nextTask.dueDate as DateTime;
    final isOverdue = dueDate.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push(RouteNames.actionPlan);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nextTask.title,
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            nextTask.priority,
                            style: AppTypography.caption.copyWith(
                              color: priorityColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: isOverdue ? AppColors.red : AppColors.neutral500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDueDate(dueDate),
                          style: AppTypography.caption.copyWith(
                            color: isOverdue ? AppColors.red : AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.neutral400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(dynamic document, BuildContext context) {
    final color = _getDocTypeColor(document.type);
    final icon = _getDocTypeIcon(document.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          document.title,
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(_formatDate(document.createdAt), style: AppTypography.caption),
        trailing: Icon(Icons.chevron_right, color: AppColors.neutral400),
        onTap: () {
          context.push('${RouteNames.documentDetails}/${document.id}');
        },
      ),
    );
  }

  Widget _buildActivityCard(dynamic activity, BuildContext context) {
    final color = _getActivityColor(activity.type);
    final icon = _getActivityIcon(activity.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          activity.title,
          style: AppTypography.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(_formatDate(activity.timestamp), style: AppTypography.caption),
        trailing: Icon(Icons.chevron_right, color: AppColors.neutral400),
        onTap: () {
          context.push(RouteNames.notifications);
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return AppColors.green;
      case 'medium':
        return AppColors.yellow;
      case 'high':
        return AppColors.orange;
      case 'critical':
        return AppColors.red;
      default:
        return AppColors.neutral500;
    }
  }

  Color _getDocTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'letter':
        return AppColors.blue;
      case 'notice':
        return AppColors.orange;
      case 'uploaded':
        return AppColors.green;
      case 'generated':
        return AppColors.secondary;
      default:
        return AppColors.neutral500;
    }
  }

  IconData _getDocTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'letter':
        return Icons.mail_outline;
      case 'notice':
        return Icons.warning_amber_outlined;
      case 'uploaded':
        return Icons.upload_file;
      case 'generated':
        return Icons.auto_awesome;
      default:
        return Icons.description_outlined;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'task':
        return AppColors.blue;
      case 'assessment':
        return AppColors.green;
      case 'deadline':
        return AppColors.red;
      case 'document':
        return AppColors.secondary;
      default:
        return AppColors.neutral500;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'task':
        return Icons.task_alt;
      case 'assessment':
        return Icons.assessment;
      case 'deadline':
        return Icons.event;
      case 'document':
        return Icons.description;
      default:
        return Icons.notifications;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
