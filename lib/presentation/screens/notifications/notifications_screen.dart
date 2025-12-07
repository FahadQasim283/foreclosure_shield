import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.mockNotifications;
    final unreadNotifications = notifications.where((n) => !n.isRead).toList();
    final readNotifications = notifications.where((n) => n.isRead).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadNotifications.isNotEmpty)
            TextButton(
              onPressed: () {
                // Mark all as read
              },
              child: Text(
                'Mark all read',
                style: AppTypography.bodySmall.copyWith(color: AppColors.white),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: AppColors.neutral300),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: AppTypography.h4.copyWith(color: AppColors.neutral500),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                if (unreadNotifications.isNotEmpty) ...[
                  _buildSectionHeader('New'),
                  ...unreadNotifications.map((notif) => _buildNotificationItem(notif, context)),
                ],
                if (readNotifications.isNotEmpty) ...[
                  _buildSectionHeader('Earlier'),
                  ...readNotifications.map((notif) => _buildNotificationItem(notif, context)),
                ],
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: AppTypography.h4.copyWith(color: AppColors.neutral600)),
    );
  }

  Widget _buildNotificationItem(dynamic notification, BuildContext context) {
    final color = _getNotificationColor(notification.type);
    final icon = _getNotificationIcon(notification.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: notification.isRead ? null : color.withOpacity(0.05),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          notification.title,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: AppTypography.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(_formatTime(notification.createdAt), style: AppTypography.caption),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              )
            : null,
        onTap: () {
          // Mark as read and navigate to related content
        },
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'alert':
        return AppColors.red;
      case 'reminder':
        return AppColors.orange;
      case 'success':
        return AppColors.green;
      case 'info':
        return AppColors.blue;
      default:
        return AppColors.neutral500;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'reminder':
        return Icons.schedule;
      case 'success':
        return Icons.check_circle;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
