import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/data/models/action_task.dart';
import '/data/mock_data.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late ActionTask task;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    // Find task by ID
    task = MockData.mockTasks.firstWhere(
      (t) => t.id == widget.taskId,
      orElse: () => MockData.mockTasks.first,
    );
    isCompleted = task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = AppColors.getPriorityColor(task.priority);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
            color: isCompleted ? AppColors.green : null,
            onPressed: () {
              setState(() {
                isCompleted = !isCompleted;
              });
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [Icon(Icons.edit, size: 20), SizedBox(width: 12), Text('Edit Task')],
                ),
              ),
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [Icon(Icons.copy, size: 20), SizedBox(width: 12), Text('Duplicate')],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [priorityColor, priorityColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.priority.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'COMPLETED',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(task.title, style: AppTypography.h1.copyWith(color: Colors.white)),
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.white.withOpacity(0.9)),
                        const SizedBox(width: 6),
                        Text(
                          'Due: ${_formatDate(task.dueDate!)}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _getDaysRemaining(task.dueDate!),
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Task Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  Text(task.description, style: AppTypography.bodyMedium),
                  const SizedBox(height: 24),

                  // Task Info
                  Text('Task Information', style: AppTypography.h3),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.flag,
                    title: 'Priority',
                    value: task.priority,
                    color: priorityColor,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.category,
                    title: 'Category',
                    value: task.category,
                    color: AppColors.blue,
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.event,
                      title: 'Due Date',
                      value: _formatDate(task.dueDate!),
                      color: AppColors.orange,
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Task Description Details
                  Text('Task Details', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neutral300),
                    ),
                    child: Text(task.description, style: AppTypography.bodyMedium),
                  ),
                  const SizedBox(height: 24),

                  // Notes Section
                  Text('Notes', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Add notes about this task...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  if (!isCompleted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isCompleted = true;
                          });
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Mark as Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            isCompleted = false;
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Mark as Incomplete'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600)),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _getDaysRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    if (difference < 0) {
      return 'Overdue by ${-difference} days';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return '1 day remaining';
    } else {
      return '$difference days remaining';
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Go back to action plan
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
