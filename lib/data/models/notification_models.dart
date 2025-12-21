import '/data/models/api_response.dart';

// ===============================
// NOTIFICATION MODEL
// ===============================
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
    );
  }
}

// ===============================
// NOTIFICATION SETTINGS MODEL
// ===============================
class NotificationSettings {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool taskReminders;
  final bool paymentReminders;
  final bool documentUpdates;

  NotificationSettings({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.taskReminders,
    required this.paymentReminders,
    required this.documentUpdates,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      taskReminders: json['taskReminders'] as bool? ?? true,
      paymentReminders: json['paymentReminders'] as bool? ?? true,
      documentUpdates: json['documentUpdates'] as bool? ?? true,
    );
  }
}

// ===============================
// REQUEST MODELS
// ===============================

class UpdateNotificationSettingsRequest {
  final bool? emailNotifications;
  final bool? pushNotifications;
  final bool? smsNotifications;
  final bool? taskReminders;
  final bool? paymentReminders;
  final bool? documentUpdates;

  UpdateNotificationSettingsRequest({
    this.emailNotifications,
    this.pushNotifications,
    this.smsNotifications,
    this.taskReminders,
    this.paymentReminders,
    this.documentUpdates,
  });

  Map<String, dynamic> toJson() {
    return {
      if (emailNotifications != null) 'emailNotifications': emailNotifications,
      if (pushNotifications != null) 'pushNotifications': pushNotifications,
      if (smsNotifications != null) 'smsNotifications': smsNotifications,
      if (taskReminders != null) 'taskReminders': taskReminders,
      if (paymentReminders != null) 'paymentReminders': paymentReminders,
      if (documentUpdates != null) 'documentUpdates': documentUpdates,
    };
  }
}

// ===============================
// RESPONSE MODELS
// ===============================

class NotificationsListResponse {
  final List<NotificationModel> notifications;
  final Pagination pagination;
  final int unreadCount;

  NotificationsListResponse({
    required this.notifications,
    required this.pagination,
    required this.unreadCount,
  });

  factory NotificationsListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsListResponse(
      notifications: (json['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
      unreadCount: json['unreadCount'] as int,
    );
  }
}

class NotificationSettingsResponse {
  final NotificationSettings settings;

  NotificationSettingsResponse({required this.settings});

  factory NotificationSettingsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsResponse(settings: NotificationSettings.fromJson(json));
  }
}

class UnreadCountResponse {
  final int count;

  UnreadCountResponse({required this.count});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(count: json['count'] as int);
  }
}
