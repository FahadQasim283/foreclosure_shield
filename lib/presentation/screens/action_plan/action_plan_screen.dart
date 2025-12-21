import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../state/action_plan_provider.dart';

class ActionPlanScreen extends StatefulWidget {
  const ActionPlanScreen({super.key});

  @override
  State<ActionPlanScreen> createState() => _ActionPlanScreenState();
}

class _ActionPlanScreenState extends State<ActionPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActionPlan();
    });
  }

  Future<void> _loadActionPlan() async {
    final actionPlanProvider = Provider.of<ActionPlanProvider>(context, listen: false);
    await actionPlanProvider.getActionPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActionPlanProvider>(
      builder: (context, actionPlanProvider, child) {
        if (actionPlanProvider.isLoading && !actionPlanProvider.hasActionPlan) {
          return Scaffold(
            appBar: AppBar(title: const Text('Action Plan')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (actionPlanProvider.hasError || !actionPlanProvider.hasActionPlan) {
          return Scaffold(
            appBar: AppBar(title: const Text('Action Plan')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.red),
                  const SizedBox(height: 16),
                  Text(
                    actionPlanProvider.errorMessage ?? 'No action plan available',
                    style: AppTypography.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: _loadActionPlan, child: const Text('Retry')),
                ],
              ),
            ),
          );
        }

        final tasks = actionPlanProvider.actionPlan!.tasks;
        final completedTasks = tasks.where((t) => t.isCompleted).length;
        final pendingTasks = tasks.length - completedTasks;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Action Plan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  // Download action plan
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _loadActionPlan,
            child: Column(
              children: [
                // Header Stats
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat('${tasks.length}', 'Total Tasks', Icons.list_alt),
                      Container(width: 1, height: 40, color: AppColors.white.withOpacity(0.3)),
                      _buildHeaderStat('$pendingTasks', 'Pending', Icons.pending_actions),
                      Container(width: 1, height: 40, color: AppColors.white.withOpacity(0.3)),
                      _buildHeaderStat('$completedTasks', 'Completed', Icons.check_circle),
                    ],
                  ),
                ),
                // Tasks List
                Expanded(child: _buildTasksList(context, tasks)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.push(RouteNames.generateLetter);
            },
            icon: const Icon(Icons.article),
            label: const Text('Generate Letters'),
          ),
        );
      },
    );
  }

  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.h2.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.white.withOpacity(0.9)),
        ),
      ],
    );
  }

  Widget _buildTasksList(BuildContext context, List tasks) {
    final categorizedTasks = {
      'immediate': tasks.where((t) => t.category == 'immediate').toList(),
      'urgent': tasks.where((t) => t.category == 'urgent').toList(),
      'important': tasks.where((t) => t.category == 'important').toList(),
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (categorizedTasks['immediate']!.isNotEmpty) ...[
          _buildCategoryHeader('Immediate Actions', AppColors.red),
          ...categorizedTasks['immediate']!.map((task) => _buildTaskItem(context, task)),
          const SizedBox(height: 16),
        ],
        if (categorizedTasks['urgent']!.isNotEmpty) ...[
          _buildCategoryHeader('Urgent Actions', AppColors.orange),
          ...categorizedTasks['urgent']!.map((task) => _buildTaskItem(context, task)),
          const SizedBox(height: 16),
        ],
        if (categorizedTasks['important']!.isNotEmpty) ...[
          _buildCategoryHeader('Important Actions', AppColors.blue),
          ...categorizedTasks['important']!.map((task) => _buildTaskItem(context, task)),
        ],
      ],
    );
  }

  Widget _buildCategoryHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(title, style: AppTypography.h4.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, dynamic task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            // Toggle task completion
          },
        ),
        title: Text(
          task.title,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              task.description,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 4),
              Text(
                'Due: ${_formatDate(task.dueDate)}',
                style: AppTypography.caption.copyWith(color: AppColors.neutral600),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to task details
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
