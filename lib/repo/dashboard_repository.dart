import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/dashboard_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class DashboardRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET DASHBOARD SUMMARY
  // ===============================
  Future<ApiResponse<DashboardSummaryResponse>> getDashboardSummary() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.dashboardSummary);

      if (response.data['success'] == true) {
        final dashboardResponse = DashboardSummaryResponse.fromJson(response.data['data']);
        return ApiResponse.success(dashboardResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch dashboard',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch dashboard',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Get dashboard error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch dashboard',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to fetch dashboard',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get dashboard error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET DASHBOARD STATISTICS
  // ===============================
  Future<ApiResponse<DashboardStatisticsResponse>> getDashboardStatistics() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.dashboardStatistics);

      if (response.data['success'] == true) {
        final statsResponse = DashboardStatisticsResponse.fromJson(response.data['data']);
        return ApiResponse.success(statsResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch statistics',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch statistics',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message'] ??
          e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      debugPrint('Get dashboard statistics error: $errorMsg');
      return ApiResponse.failure(
        e.response?.data?['message'] ??
            e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch statistics',
        error: ApiError(
          message:
              e.response?.data?['message'] ??
              e.response?.data?['error']?['message'] ??
              e.message ??
              'Failed to fetch statistics',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get dashboard statistics error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
