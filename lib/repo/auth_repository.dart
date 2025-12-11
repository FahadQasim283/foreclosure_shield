import 'dart:convert';
import '../services/network/api_client.dart' show ApiClient;
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/user.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // SIGNUP
  // ===============================
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.signup,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      if (response['success'] == true) {
        // Save token
        final token = response['data']['token'];
        final refreshToken = response['data']['refreshToken'];
        await TokenStorage.saveToken(token);
        await TokenStorage.saveRefreshToken(refreshToken);

        // Parse user
        final user = User.fromJson(response['data']['user']);

        return {'success': true, 'user': user, 'token': token, 'refreshToken': refreshToken};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Signup error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // LOGIN
  // ===============================
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response['success'] == true) {
        // Save tokens
        final token = response['data']['token'];
        final refreshToken = response['data']['refreshToken'];
        await TokenStorage.saveToken(token);
        await TokenStorage.saveRefreshToken(refreshToken);

        // Parse user
        final user = User.fromJson(response['data']['user']);

        return {'success': true, 'user': user, 'token': token, 'refreshToken': refreshToken};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Login error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // FORGOT PASSWORD
  // ===============================
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.forgotPassword, data: {'email': email});

      if (response['success'] == true) {
        return {'success': true, 'message': response['message']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Forgot password error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // VERIFY OTP
  // ===============================
  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp},
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'verified': response['data']['verified'],
          'resetToken': response['data']['resetToken'],
        };
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // RESET PASSWORD
  // ===============================
  Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          'resetToken': resetToken,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response['success'] == true) {
        return {'success': true, 'message': response['message']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Reset password error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // REFRESH TOKEN
  // ===============================
  Future<Map<String, dynamic>> refreshAccessToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return {'success': false, 'message': 'No refresh token found'};
      }

      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response['success'] == true) {
        final newToken = response['data']['token'];
        final newRefreshToken = response['data']['refreshToken'];

        await TokenStorage.saveToken(newToken);
        await TokenStorage.saveRefreshToken(newRefreshToken);

        return {'success': true, 'token': newToken, 'refreshToken': newRefreshToken};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Refresh token error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // LOGOUT
  // ===============================
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = await TokenStorage.getToken();

      if (token != null) {
        await _apiClient.post(
          ApiEndpoints.logout,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }

      // Clear local tokens
      await TokenStorage.clearTokens();

      return {'success': true, 'message': 'Logout successful'};
    } catch (e) {
      debugPrint('Logout error: $e');
      // Clear tokens even if API call fails
      await TokenStorage.clearTokens();
      return {'success': true, 'message': 'Logout successful'};
    }
  }

  // ===============================
  // GET CURRENT USER
  // ===============================
  Future<User?> getCurrentUser() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return null;

      final response = await _apiClient.get(
        ApiEndpoints.userProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        return User.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      debugPrint('Get current user error: $e');
      return null;
    }
  }

  // ===============================
  // CHECK IF LOGGED IN
  // ===============================
  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
