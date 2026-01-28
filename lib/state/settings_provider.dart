import 'package:flutter/foundation.dart';
import '../data/models/settings_models.dart';
import '../repo/settings_repository.dart';
import '../services/local_storage/token_storage.dart';
import '../core/utils/error_handler.dart';

enum SettingsState { idle, loading, success, error }

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository = SettingsRepository();

  SettingsState _state = SettingsState.idle;
  AppSettings? _settings;
  String? _errorMessage;

  // Getters
  SettingsState get state => _state;
  AppSettings? get settings => _settings;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == SettingsState.loading;
  bool get hasError => _state == SettingsState.error;
  bool get hasSettings => _settings != null;

  // Individual settings getters for convenience
  NotificationPreferences? get notificationPreferences => _settings?.notifications;
  PrivacySettings? get privacySettings => _settings?.privacy;
  AppPreferences? get appPreferences => _settings?.preferences;

  // Get Settings
  Future<bool> getSettings() async {
    _setState(SettingsState.loading);
    _errorMessage = null;

    try {
      final response = await _settingsRepository.getSettings();

      if (response.success && response.data != null) {
        _settings = response.data!.settings;
        _setState(SettingsState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch settings';
        _setState(SettingsState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to fetch settings');
      _setState(SettingsState.error);
      return false;
    }
  }

  // Update Settings
  Future<bool> updateSettings(UpdateSettingsRequest request) async {
    _setState(SettingsState.loading);
    _errorMessage = null;

    try {
      final response = await _settingsRepository.updateSettings(request);

      if (response.success && response.data != null) {
        _settings = response.data!.settings;
        _setState(SettingsState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to update settings';
        _setState(SettingsState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to update settings');
      _setState(SettingsState.error);
      return false;
    }
  }

  // Update Notification Preferences
  Future<bool> updateNotificationPreferences(NotificationPreferences preferences) async {
    final request = UpdateSettingsRequest(
      notifications: {
        'emailNotifications': preferences.emailNotifications,
        'pushNotifications': preferences.pushNotifications,
        'smsNotifications': preferences.smsNotifications,
        'taskReminders': preferences.taskReminders,
        'paymentReminders': preferences.paymentReminders,
        'documentUpdates': preferences.documentUpdates,
        'marketingEmails': preferences.marketingEmails,
      },
    );
    return await updateSettings(request);
  }

  // Update Privacy Settings
  Future<bool> updatePrivacySettings(PrivacySettings privacy) async {
    final request = UpdateSettingsRequest(
      privacy: {
        'profileVisibility': privacy.profileVisibility,
        'dataSharing': privacy.dataSharing,
        'analyticsTracking': privacy.analyticsTracking,
      },
    );
    return await updateSettings(request);
  }

  // Update App Preferences
  Future<bool> updateAppPreferences(AppPreferences preferences) async {
    final request = UpdateSettingsRequest(
      preferences: {
        'language': preferences.language,
        'theme': preferences.theme,
        'currency': preferences.currency,
        'dateFormat': preferences.dateFormat,
      },
    );
    return await updateSettings(request);
  }

  // Change Password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setState(SettingsState.loading);
    _errorMessage = null;

    if (newPassword != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      _setState(SettingsState.error);
      return false;
    }

    try {
      final response = await _settingsRepository.changePassword(
        ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );

      if (response.success) {
        _setState(SettingsState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to change password';
        _setState(SettingsState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to change password');
      _setState(SettingsState.error);
      return false;
    }
  }

  // Delete Account
  Future<bool> deleteAccount({required String password, String? reason}) async {
    _setState(SettingsState.loading);
    _errorMessage = null;

    try {
      final response = await _settingsRepository.deleteAccount(
        DeleteAccountRequest(password: password, reason: reason),
      );

      if (response.success) {
        // Account deleted, clear all local data
        _settings = null;
        await TokenStorage.clearAll();
        _setState(SettingsState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to delete account';
        _setState(SettingsState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to update settings');
      _setState(SettingsState.error);
      return false;
    }
  }

  // Toggle specific notification preference
  Future<bool> toggleNotification(String key, bool value) async {
    if (_settings == null) return false;

    final currentPrefs = _settings!.notifications;
    NotificationPreferences newPrefs;

    switch (key) {
      case 'emailNotifications':
        newPrefs = NotificationPreferences(
          emailNotifications: value,
          pushNotifications: currentPrefs.pushNotifications,
          smsNotifications: currentPrefs.smsNotifications,
          taskReminders: currentPrefs.taskReminders,
          paymentReminders: currentPrefs.paymentReminders,
          documentUpdates: currentPrefs.documentUpdates,
          marketingEmails: currentPrefs.marketingEmails,
        );
        break;
      case 'pushNotifications':
        newPrefs = NotificationPreferences(
          emailNotifications: currentPrefs.emailNotifications,
          pushNotifications: value,
          smsNotifications: currentPrefs.smsNotifications,
          taskReminders: currentPrefs.taskReminders,
          paymentReminders: currentPrefs.paymentReminders,
          documentUpdates: currentPrefs.documentUpdates,
          marketingEmails: currentPrefs.marketingEmails,
        );
        break;
      case 'smsNotifications':
        newPrefs = NotificationPreferences(
          emailNotifications: currentPrefs.emailNotifications,
          pushNotifications: currentPrefs.pushNotifications,
          smsNotifications: value,
          taskReminders: currentPrefs.taskReminders,
          paymentReminders: currentPrefs.paymentReminders,
          documentUpdates: currentPrefs.documentUpdates,
          marketingEmails: currentPrefs.marketingEmails,
        );
        break;
      case 'taskReminders':
        newPrefs = NotificationPreferences(
          emailNotifications: currentPrefs.emailNotifications,
          pushNotifications: currentPrefs.pushNotifications,
          smsNotifications: currentPrefs.smsNotifications,
          taskReminders: value,
          paymentReminders: currentPrefs.paymentReminders,
          documentUpdates: currentPrefs.documentUpdates,
          marketingEmails: currentPrefs.marketingEmails,
        );
        break;
      case 'paymentReminders':
        newPrefs = NotificationPreferences(
          emailNotifications: currentPrefs.emailNotifications,
          pushNotifications: currentPrefs.pushNotifications,
          smsNotifications: currentPrefs.smsNotifications,
          taskReminders: currentPrefs.taskReminders,
          paymentReminders: value,
          documentUpdates: currentPrefs.documentUpdates,
          marketingEmails: currentPrefs.marketingEmails,
        );
        break;
      case 'documentUpdates':
        newPrefs = NotificationPreferences(
          emailNotifications: currentPrefs.emailNotifications,
          pushNotifications: currentPrefs.pushNotifications,
          smsNotifications: currentPrefs.smsNotifications,
          taskReminders: currentPrefs.taskReminders,
          paymentReminders: currentPrefs.paymentReminders,
          documentUpdates: value,
          marketingEmails: currentPrefs.marketingEmails,
        );
        break;
      case 'marketingEmails':
        newPrefs = NotificationPreferences(
          emailNotifications: currentPrefs.emailNotifications,
          pushNotifications: currentPrefs.pushNotifications,
          smsNotifications: currentPrefs.smsNotifications,
          taskReminders: currentPrefs.taskReminders,
          paymentReminders: currentPrefs.paymentReminders,
          documentUpdates: currentPrefs.documentUpdates,
          marketingEmails: value,
        );
        break;
      default:
        return false;
    }

    return await updateNotificationPreferences(newPrefs);
  }

  // Toggle theme
  Future<bool> toggleTheme(String theme) async {
    if (_settings == null) return false;

    final newPrefs = AppPreferences(
      language: _settings!.preferences.language,
      theme: theme,
      currency: _settings!.preferences.currency,
      dateFormat: _settings!.preferences.dateFormat,
      timeFormat: _settings!.preferences.timeFormat,
    );

    return await updateAppPreferences(newPrefs);
  }

  // Change language
  Future<bool> changeLanguage(String language) async {
    if (_settings == null) return false;

    final newPrefs = AppPreferences(
      language: language,
      theme: _settings!.preferences.theme,
      currency: _settings!.preferences.currency,
      dateFormat: _settings!.preferences.dateFormat,
      timeFormat: _settings!.preferences.timeFormat,
    );

    return await updateAppPreferences(newPrefs);
  }

  // Refresh settings (silent)
  Future<void> refreshSettings() async {
    try {
      final response = await _settingsRepository.getSettings();
      if (response.success && response.data != null) {
        _settings = response.data!.settings;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _settings = null;
    _errorMessage = null;
    _setState(SettingsState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == SettingsState.error) {
      _setState(SettingsState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(SettingsState newState) {
    _state = newState;
    notifyListeners();
  }
}
