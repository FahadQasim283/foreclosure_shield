import 'package:flutter/foundation.dart';
import '../data/models/api_response.dart';
import '../data/models/notification_models.dart';
import '../repo/notification_repository.dart';

enum NotificationState { idle, loading, success, error }

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _notificationRepository = NotificationRepository();

  NotificationState _state = NotificationState.idle;
  List<NotificationModel> _notifications = [];
  NotificationSettings? _settings;
  int _unreadCount = 0;
  String? _errorMessage;

  // Getters
  NotificationState get state => _state;
  List<NotificationModel> get notifications => _notifications;
  NotificationSettings? get settings => _settings;
  int get unreadCount => _unreadCount;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == NotificationState.loading;
  bool get hasError => _state == NotificationState.error;
  bool get hasNotifications => _notifications.isNotEmpty;
  bool get hasUnread => _unreadCount > 0;

  // Computed getters
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  List<NotificationModel> get readNotifications => _notifications.where((n) => n.isRead).toList();

  // Get Notifications
  Future<bool> getNotifications({int page = 1, int limit = 20, bool? unreadOnly}) async {
    _setState(NotificationState.loading);
    _errorMessage = null;

    try {
      final response = await _notificationRepository.getNotifications(
        page: page,
        limit: limit,
        unreadOnly: unreadOnly,
      );

      if (response.success && response.data != null) {
        if (page == 1) {
          _notifications = response.data!.notifications;
        } else {
          _notifications.addAll(response.data!.notifications);
        }
        _unreadCount = response.data!.unreadCount;
        _setState(NotificationState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch notifications';
        _setState(NotificationState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(NotificationState.error);
      return false;
    }
  }

  // Get Unread Count
  Future<void> getUnreadCount() async {
    try {
      final response = await _notificationRepository.getUnreadCount();
      if (response.success && response.data != null) {
        _unreadCount = response.data!.count;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Mark as Read
  Future<bool> markAsRead(String notificationId) async {
    _errorMessage = null;

    // Optimistic update
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
      notifyListeners();
    }

    try {
      final response = await _notificationRepository.markAsRead(notificationId);

      if (response.success) {
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to mark as read';
        // Refresh to get correct state
        await getNotifications();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      await getNotifications();
      return false;
    }
  }

  // Mark All as Read
  Future<bool> markAllAsRead() async {
    _errorMessage = null;

    // Optimistic update
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _unreadCount = 0;
    notifyListeners();

    try {
      final response = await _notificationRepository.markAllAsRead();

      if (response.success) {
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to mark all as read';
        await getNotifications();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      await getNotifications();
      return false;
    }
  }

  // Delete Notification
  Future<bool> deleteNotification(String notificationId) async {
    _errorMessage = null;

    // Optimistic delete
    final deletedNotification = _notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => _notifications.first,
    );
    final wasUnread = !deletedNotification.isRead;

    _notifications.removeWhere((n) => n.id == notificationId);
    if (wasUnread) {
      _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
    }
    notifyListeners();

    try {
      final response = await _notificationRepository.deleteNotification(notificationId);

      if (response.success) {
        return true;
      } else {
        // Revert delete
        _notifications.add(deletedNotification);
        if (wasUnread) _unreadCount++;
        _errorMessage = response.error?.message ?? 'Failed to delete notification';
        notifyListeners();
        return false;
      }
    } catch (e) {
      // Revert delete
      _notifications.add(deletedNotification);
      if (wasUnread) _unreadCount++;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get Notification Settings
  Future<bool> getNotificationSettings() async {
    _setState(NotificationState.loading);
    _errorMessage = null;

    try {
      final response = await _notificationRepository.getNotificationSettings();

      if (response.success && response.data != null) {
        _settings = response.data!.settings;
        _setState(NotificationState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch settings';
        _setState(NotificationState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(NotificationState.error);
      return false;
    }
  }

  // Update Notification Settings
  Future<bool> updateNotificationSettings(UpdateNotificationSettingsRequest request) async {
    _errorMessage = null;

    try {
      final response = await _notificationRepository.updateNotificationSettings(request);

      if (response.success && response.data != null) {
        _settings = response.data!.settings;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to update settings';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Refresh notifications (silent)
  Future<void> refreshNotifications() async {
    try {
      final response = await _notificationRepository.getNotifications();
      if (response.success && response.data != null) {
        _notifications = response.data!.notifications;
        _unreadCount = response.data!.unreadCount;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _notifications = [];
    _settings = null;
    _unreadCount = 0;
    _errorMessage = null;
    _setState(NotificationState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == NotificationState.error) {
      _setState(NotificationState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(NotificationState newState) {
    _state = newState;
    notifyListeners();
  }
}
