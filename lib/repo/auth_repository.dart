import '../services/network/api_client.dart' show ApiClient;
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/user.dart';
import '/data/models/api_response.dart';
import '/data/models/auth_models.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // SIGNUP
  // ===============================
  Future<ApiResponse<AuthResponse>> signup(SignupRequest request) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.signup, data: request.toJson());

      if (response.data['success'] == true) {
        final authResponse = AuthResponse.fromJson(response.data['data']);

        // Save tokens
        await TokenStorage.saveTokens(
          accessToken: authResponse.token,
          refreshToken: authResponse.refreshToken,
        );

        return ApiResponse.success(authResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Signup failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Signup failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Signup error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Signup failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Signup failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Signup error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // LOGIN
  // ===============================
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.login, data: request.toJson());

      if (response.data['success'] == true) {
        final authResponse = AuthResponse.fromJson(response.data['data']);

        // Save tokens
        await TokenStorage.saveTokens(
          accessToken: authResponse.token,
          refreshToken: authResponse.refreshToken,
        );

        return ApiResponse.success(authResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Login failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Login failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Login error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Login failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Login failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Login error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // FORGOT PASSWORD
  // ===============================
  Future<ApiResponse<ForgotPasswordResponse>> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.forgotPassword, data: request.toJson());

      if (response.data['success'] == true) {
        final forgotResponse = ForgotPasswordResponse.fromJson(response.data['data']);
        return ApiResponse.success(forgotResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Forgot password failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Forgot password failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Forgot password error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Forgot password failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Forgot password failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Forgot password error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // VERIFY OTP
  // ===============================
  Future<ApiResponse<VerifyOtpResponse>> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.verifyOtp, data: request.toJson());

      if (response.data['success'] == true) {
        final verifyResponse = VerifyOtpResponse.fromJson(response.data['data']);
        return ApiResponse.success(verifyResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'OTP verification failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'OTP verification failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Verify OTP error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'OTP verification failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'OTP verification failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // RESET PASSWORD
  // ===============================
  Future<ApiResponse<ResetPasswordResponse>> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.resetPassword, data: request.toJson());

      if (response.data['success'] == true) {
        final resetResponse = ResetPasswordResponse.fromJson(response.data['data']);
        return ApiResponse.success(resetResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Password reset failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Password reset failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Reset password error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Password reset failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Password reset failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Reset password error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // REFRESH TOKEN
  // ===============================
  Future<ApiResponse<RefreshTokenResponse>> refreshAccessToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return ApiResponse.failure(
          'No refresh token found',
          error: ApiError(message: 'No refresh token found'),
        );
      }

      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );

      if (response.data['success'] == true) {
        final refreshResponse = RefreshTokenResponse.fromJson(response.data['data']);

        // Save new tokens
        await TokenStorage.saveTokens(
          accessToken: refreshResponse.token,
          refreshToken: refreshResponse.refreshToken,
        );

        return ApiResponse.success(refreshResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Token refresh failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Token refresh failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Refresh token error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Token refresh failed',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Token refresh failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Refresh token error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // LOGOUT
  // ===============================
  Future<ApiResponse<void>> logout() async {
    try {
      final token = await TokenStorage.getAccessToken();

      if (token != null) {
        await _apiClient.post(ApiEndpoints.logout);
      }

      // Clear local tokens
      await TokenStorage.clearAll();

      return ApiResponse.success(null, message: 'Logout successful');
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Logout error: $errorMsg');
      // Clear tokens even if API call fails
      await TokenStorage.clearAll();
      return ApiResponse.success(null, message: 'Logout successful');
    } catch (e) {
      debugPrint('Logout error: $e');
      // Clear tokens even if API call fails
      await TokenStorage.clearAll();
      return ApiResponse.success(null, message: 'Logout successful');
    }
  }

  // ===============================
  // GET CURRENT USER
  // ===============================
  Future<ApiResponse<User>> getCurrentUser() async {
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
        final user = User.fromJson(response.data['data']);
        return ApiResponse.success(user, message: response.data['message'] as String?);
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
      debugPrint('Get current user error: $errorMsg');
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
      debugPrint('Get current user error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // CHECK IF LOGGED IN
  // ===============================
  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
