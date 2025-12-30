import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/user_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class UserRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET USER PROFILE
  // ===============================
  Future<ApiResponse<UserProfileResponse>> getUserProfile() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.userProfile);

      if (response.data['success'] == true) {
        final userResponse = UserProfileResponse.fromJson(response.data['data']);
        return ApiResponse.success(userResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch profile',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch profile',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Get user profile error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch profile',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to fetch profile',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPDATE USER PROFILE
  // ===============================
  Future<ApiResponse<UpdateProfileResponse>> updateProfile(UpdateProfileRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.put(ApiEndpoints.updateProfile, data: request.toJson());

      if (response.data['success'] == true) {
        final updateResponse = UpdateProfileResponse.fromJson(response.data['data']);
        return ApiResponse.success(updateResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Profile update failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Profile update failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Update profile error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Profile update failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Profile update failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Update profile error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPDATE USER PROFILE
  // ===============================
  Future<ApiResponse<UpdateProfileResponse>> updateUserProfile(UpdateProfileRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.put(ApiEndpoints.updateProfile, data: request.toJson());

      if (response.data['success'] == true) {
        final updateResponse = UpdateProfileResponse.fromJson(response.data['data']);
        return ApiResponse.success(updateResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to update profile',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to update profile',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Update profile error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to update profile',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to update profile',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Update profile error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPLOAD PROFILE IMAGE
  // ===============================
  Future<ApiResponse<UploadProfileImageResponse>> uploadProfileImage(
    String filePath, {
    Function(double)? onProgress,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final formData = FormData.fromMap({'image': await MultipartFile.fromFile(filePath)});

      final response = await _apiClient.post(ApiEndpoints.uploadProfileImage, data: formData);

      if (response.data['success'] == true) {
        final uploadResponse = UploadProfileImageResponse.fromJson(response.data['data']);
        return ApiResponse.success(uploadResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Image upload failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Image upload failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Upload profile image error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Image upload failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Image upload failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Upload profile image error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET USER BY ID
  // ===============================
  Future<ApiResponse<UserProfileResponse>> getUserById(String userId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.getUserById(userId));

      if (response.data['success'] == true) {
        final userResponse = UserProfileResponse.fromJson(response.data['data']);
        return ApiResponse.success(userResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch user',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch user',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Get user by ID error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch user',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to fetch user',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get user by ID error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
