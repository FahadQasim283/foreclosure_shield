import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/device_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class DeviceRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // REGISTER DEVICE FOR PUSH NOTIFICATIONS
  // ===============================
  Future<ApiResponse<RegisterDeviceResponse>> registerDevice(RegisterDeviceRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(ApiEndpoints.registerDevice, data: request.toJson());

      if (response.data['success'] == true) {
        final deviceResponse = RegisterDeviceResponse.fromJson(response.data['data']);
        return ApiResponse.success(deviceResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to register device',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to register device',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Register device error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to register device',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to register device',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Register device error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UNREGISTER DEVICE
  // ===============================
  Future<ApiResponse<UnregisterDeviceResponse>> unregisterDevice(String deviceId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.delete(ApiEndpoints.unregisterDevice(deviceId));

      if (response.data['success'] == true) {
        final unregisterResponse = UnregisterDeviceResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          unregisterResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to unregister device',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to unregister device',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Unregister device error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to unregister device',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to unregister device',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Unregister device error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET ALL DEVICES
  // ===============================
  Future<ApiResponse<List<Device>>> getAllDevices() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.allDevices);

      if (response.data['success'] == true) {
        final List<dynamic> devicesData = response.data['data'] as List<dynamic>;
        final devices = devicesData.map((json) => Device.fromJson(json)).toList();
        return ApiResponse.success(devices, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch devices',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch devices',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Get all devices error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch devices',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to fetch devices',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get all devices error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
