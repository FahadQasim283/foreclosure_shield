import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/settings_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class SettingsRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET SETTINGS
  // ===============================
  Future<ApiResponse<SettingsResponse>> getSettings() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.settings);

      if (response.data['success'] == true) {
        final settingsResponse = SettingsResponse.fromJson(response.data['data']);
        return ApiResponse.success(settingsResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch settings',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch settings',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Get settings error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch settings',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to fetch settings',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get settings error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPDATE SETTINGS
  // ===============================
  Future<ApiResponse<SettingsResponse>> updateSettings(UpdateSettingsRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.put(ApiEndpoints.updateSettings, data: request.toJson());

      if (response.data['success'] == true) {
        final settingsResponse = SettingsResponse.fromJson(response.data['data']);
        return ApiResponse.success(settingsResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to update settings',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to update settings',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Update settings error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to update settings',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to update settings',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Update settings error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // CHANGE PASSWORD
  // ===============================
  Future<ApiResponse<ChangePasswordResponse>> changePassword(ChangePasswordRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(ApiEndpoints.changePassword, data: request.toJson());

      if (response.data['success'] == true) {
        final changeResponse = ChangePasswordResponse.fromJson(response.data['data']);
        return ApiResponse.success(changeResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to change password',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to change password',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Change password error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to change password',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to change password',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Change password error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // DELETE ACCOUNT
  // ===============================
  Future<ApiResponse<DeleteAccountResponse>> deleteAccount(DeleteAccountRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.delete(ApiEndpoints.deleteAccount);

      if (response.data['success'] == true) {
        final deleteResponse = DeleteAccountResponse.fromJson(response.data['data']);
        // Clear tokens after account deletion
        await TokenStorage.clearAll();
        return ApiResponse.success(deleteResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to delete account',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to delete account',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Delete account error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to delete account',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to delete account',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Delete account error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
