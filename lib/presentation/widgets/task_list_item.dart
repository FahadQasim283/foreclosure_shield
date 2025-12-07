import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../data/models/action_task.dart';

class TaskListItem extends StatelessWidget {
  final ActionTask task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const TaskListItem({super.key, required this.task, this.onTap, this.onToggleComplete});

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppWidgetStyles.elevatedCard,
          child: Row(
            children: [
              // Priority Indicator
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Checkbox
              Checkbox(
                value: task.isCompleted,
                onChanged: onToggleComplete != null ? (_) => onToggleComplete!() : null,
              ),
              const SizedBox(width: 12),
              // Task Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTypography.bodyMedium.copyWith(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.neutral600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: _isDueSoon(task.dueDate!) ? AppColors.red : AppColors.neutral500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(task.dueDate!),
                            style: AppTypography.caption.copyWith(
                              color: _isDueSoon(task.dueDate!)
                                  ? AppColors.red
                                  : AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow Icon
              Icon(Icons.chevron_right, color: AppColors.neutral400),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return AppColors.orange;
      case 'low':
        return AppColors.green;
      default:
        return AppColors.neutral500;
    }
  }

  bool _isDueSoon(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference <= 2 && difference >= 0;
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) return 'Due today';
    if (difference == 1) return 'Due tomorrow';
    if (difference < 0) return 'Overdue';
    if (difference <= 7) return 'Due in $difference days';

    return 'Due ${date.day}/${date.month}/${date.year}';
  }
}
