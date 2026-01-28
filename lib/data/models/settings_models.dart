// ===============================
// APP SETTINGS MODEL
// ===============================
class AppSettings {
  final NotificationPreferences notifications;
  final PrivacySettings privacy;
  final AppPreferences preferences;

  AppSettings({required this.notifications, required this.privacy, required this.preferences});

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      notifications: NotificationPreferences.fromJson(json['notifications']),
      privacy: PrivacySettings.fromJson(json['privacy']),
      preferences: AppPreferences.fromJson(json['preferences']),
    );
  }
}

// ===============================
// NOTIFICATION PREFERENCES MODEL
// ===============================
class NotificationPreferences {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool taskReminders;
  final bool paymentReminders;
  final bool documentUpdates;
  final bool marketingEmails;

  NotificationPreferences({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.taskReminders,
    required this.paymentReminders,
    required this.documentUpdates,
    required this.marketingEmails,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      taskReminders: json['taskReminders'] as bool? ?? true,
      paymentReminders: json['paymentReminders'] as bool? ?? true,
      documentUpdates: json['documentUpdates'] as bool? ?? true,
      marketingEmails: json['marketingEmails'] as bool? ?? false,
    );
  }
}

// ===============================
// PRIVACY SETTINGS MODEL
// ===============================
class PrivacySettings {
  final bool profileVisibility;
  final bool dataSharing;
  final bool analyticsTracking;

  PrivacySettings({
    required this.profileVisibility,
    required this.dataSharing,
    required this.analyticsTracking,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      profileVisibility: json['profileVisibility'] as bool? ?? false,
      dataSharing: json['dataSharing'] as bool? ?? false,
      analyticsTracking: json['analyticsTracking'] as bool? ?? true,
    );
  }
}

// ===============================
// APP PREFERENCES MODEL
// ===============================
class AppPreferences {
  final String language;
  final String theme;
  final String currency;
  final String dateFormat;
  final String timeFormat;

  AppPreferences({
    required this.language,
    required this.theme,
    required this.currency,
    required this.dateFormat,
    required this.timeFormat,
  });

  factory AppPreferences.fromJson(Map<String, dynamic> json) {
    return AppPreferences(
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'light',
      currency: json['currency'] as String? ?? 'USD',
      dateFormat: json['dateFormat'] as String? ?? 'MM/DD/YYYY',
      timeFormat: json['timeFormat'] as String? ?? '12h',
    );
  }
}

// ===============================
// REQUEST MODELS
// ===============================

class UpdateSettingsRequest {
  final Map<String, dynamic>? notifications;
  final Map<String, dynamic>? privacy;
  final Map<String, dynamic>? preferences;

  UpdateSettingsRequest({this.notifications, this.privacy, this.preferences});

  Map<String, dynamic> toJson() {
    return {
      if (notifications != null) 'notifications': notifications,
      if (privacy != null) 'privacy': privacy,
      if (preferences != null) 'preferences': preferences,
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class DeleteAccountRequest {
  final String password;
  final String? reason;

  DeleteAccountRequest({required this.password, this.reason});

  Map<String, dynamic> toJson() {
    return {'password': password, if (reason != null) 'reason': reason};
  }
}

// ===============================
// RESPONSE MODELS
// ===============================

class SettingsResponse {
  final AppSettings settings;

  SettingsResponse({required this.settings});

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(settings: AppSettings.fromJson(json));
  }
}

class ChangePasswordResponse {
  final bool success;
  final DateTime changedAt;

  ChangePasswordResponse({required this.success, required this.changedAt});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      success: json['success'] as bool,
      changedAt: DateTime.parse(json['changedAt'] as String),
    );
  }
}

class DeleteAccountResponse {
  final bool deleted;
  final DateTime deletedAt;

  DeleteAccountResponse({required this.deleted, required this.deletedAt});

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      deleted: json['deleted'] as bool,
      deletedAt: DateTime.parse(json['deletedAt'] as String),
    );
  }
}
