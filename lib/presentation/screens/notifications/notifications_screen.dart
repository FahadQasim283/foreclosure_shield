import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../state/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    await notificationProvider.getNotifications();
  }

  Future<void> _markAllAsRead() async {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    await notificationProvider.markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              if (notificationProvider.hasUnread)
                TextButton(
                  onPressed: notificationProvider.isLoading ? null : _markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.white),
                  ),
                ),
            ],
          ),
          body: _buildBody(notificationProvider),
        );
      },
    );
  }

  Widget _buildBody(NotificationProvider provider) {
    if (provider.isLoading && !provider.hasNotifications) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Failed to load notifications',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _loadNotifications, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (!provider.hasNotifications) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: AppColors.neutral300),
            const SizedBox(height: 16),
            Text('No notifications', style: AppTypography.h4.copyWith(color: AppColors.neutral500)),
          ],
        ),
      );
    }

    final unreadNotifications = provider.unreadNotifications;
    final readNotifications = provider.readNotifications;

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView(
        children: [
          if (unreadNotifications.isNotEmpty) ...[
            _buildSectionHeader('New'),
            ...unreadNotifications.map((notif) => _buildNotificationItem(notif, context, provider)),
          ],
          if (readNotifications.isNotEmpty) ...[
            _buildSectionHeader('Earlier'),
            ...readNotifications.map((notif) => _buildNotificationItem(notif, context, provider)),
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

  Widget _buildNotificationItem(
    dynamic notification,
    BuildContext context,
    NotificationProvider provider,
  ) {
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
        onTap: () async {
          if (!notification.isRead) {
            await provider.markAsRead(notification.id);
          }
          // Navigate to related content if needed
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
