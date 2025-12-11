import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/notification_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class NotificationRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET ALL NOTIFICATIONS
  // ===============================
  Future<ApiResponse<NotificationsListResponse>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      String url = '${ApiEndpoints.notifications}?page=$page&limit=$limit';
      if (unreadOnly != null && unreadOnly) {
        url += '&unreadOnly=true';
      }

      final response = await _apiClient.get(url);

      if (response.data['success'] == true) {
        final notificationsResponse = NotificationsListResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          notificationsResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch notifications',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch notifications',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get notifications error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch notifications',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch notifications',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get notifications error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET UNREAD COUNT
  // ===============================
  Future<ApiResponse<UnreadCountResponse>> getUnreadCount() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.notificationUnreadCount);

      if (response.data['success'] == true) {
        final countResponse = UnreadCountResponse.fromJson(response.data['data']);
        return ApiResponse.success(countResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch unread count',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch unread count',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get unread count error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch unread count',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch unread count',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get unread count error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // MARK NOTIFICATION AS READ
  // ===============================
  Future<ApiResponse<void>> markAsRead(String notificationId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.patch(
        '${ApiEndpoints.markNotificationRead}/$notificationId/read',
      );

      if (response.data['success'] == true) {
        return ApiResponse.success(
          null,
          message: response.data['message'] as String? ?? 'Notification marked as read',
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to mark notification as read',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to mark notification as read',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Mark as read error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to mark notification as read',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ??
              e.message ??
              'Failed to mark notification as read',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Mark as read error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // MARK ALL AS READ
  // ===============================
  Future<ApiResponse<void>> markAllAsRead() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.patch(ApiEndpoints.markAllRead);

      if (response.data['success'] == true) {
        return ApiResponse.success(
          null,
          message: response.data['message'] as String? ?? 'All notifications marked as read',
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to mark all as read',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to mark all as read',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Mark all as read error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to mark all as read',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to mark all as read',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Mark all as read error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // DELETE NOTIFICATION
  // ===============================
  Future<ApiResponse<void>> deleteNotification(String notificationId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.delete(
        '${ApiEndpoints.deleteNotification}/$notificationId',
      );

      if (response.data['success'] == true) {
        return ApiResponse.success(
          null,
          message: response.data['message'] as String? ?? 'Notification deleted successfully',
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to delete notification',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to delete notification',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Delete notification error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to delete notification',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to delete notification',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Delete notification error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET NOTIFICATION SETTINGS
  // ===============================
  Future<ApiResponse<NotificationSettingsResponse>> getNotificationSettings() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.notificationSettings);

      if (response.data['success'] == true) {
        final settingsResponse = NotificationSettingsResponse.fromJson(response.data['data']);
        return ApiResponse.success(settingsResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch notification settings',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch notification settings',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get notification settings error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ??
            e.message ??
            'Failed to fetch notification settings',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ??
              e.message ??
              'Failed to fetch notification settings',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get notification settings error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPDATE NOTIFICATION SETTINGS
  // ===============================
  Future<ApiResponse<NotificationSettingsResponse>> updateNotificationSettings(
    UpdateNotificationSettingsRequest request,
  ) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.put(
        ApiEndpoints.updateNotificationSettings,
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final settingsResponse = NotificationSettingsResponse.fromJson(response.data['data']);
        return ApiResponse.success(settingsResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to update notification settings',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to update notification settings',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Update notification settings error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ??
            e.message ??
            'Failed to update notification settings',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ??
              e.message ??
              'Failed to update notification settings',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Update notification settings error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
