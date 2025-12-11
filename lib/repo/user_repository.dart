import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/user.dart';
import 'package:flutter/material.dart' show debugPrint;

class UserRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET USER PROFILE
  // ===============================
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.get(
        ApiEndpoints.userProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final user = User.fromJson(response['data']);
        return {'success': true, 'user': user};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // UPDATE USER PROFILE
  // ===============================
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? propertyAddress,
    String? city,
    String? state,
    String? zipCode,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (propertyAddress != null) data['propertyAddress'] = propertyAddress;
      if (city != null) data['city'] = city;
      if (state != null) data['state'] = state;
      if (zipCode != null) data['zipCode'] = zipCode;

      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final user = User.fromJson(response['data']);
        return {'success': true, 'user': user, 'message': response['message']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Update profile error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // UPLOAD PROFILE IMAGE
  // ===============================
  Future<Map<String, dynamic>> uploadProfileImage(String filePath) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final formData = FormData.fromMap({'image': await MultipartFile.fromFile(filePath)});

      final response = await _apiClient.post(
        ApiEndpoints.uploadProfileImage,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'profileImage': response['data']['profileImage'],
          'message': response['message'],
        };
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Upload profile image error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
