import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/risk_assessment.dart';
import '/data/models/api_response.dart';
import '/data/models/assessment_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class AssessmentRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // CREATE ASSESSMENT
  // ===============================
  Future<ApiResponse<AssessmentResponse>> createAssessment(CreateAssessmentRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(
        ApiEndpoints.createAssessment,
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final assessmentResponse = AssessmentResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          assessmentResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Assessment creation failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Assessment creation failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Create assessment error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Assessment creation failed',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Assessment creation failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Create assessment error: $e');
      return ApiResponse.failure(
        e.toString(),
        error: ApiError(message: e.toString()),
      );
    }
  }

  // ===============================
  // GET ASSESSMENT BY ID
  // ===============================
  Future<ApiResponse<AssessmentResponse>> getAssessmentById(String assessmentId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get('${ApiEndpoints.getAssessment}/$assessmentId');

      if (response.data['success'] == true) {
        final assessmentResponse = AssessmentResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          assessmentResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch assessment',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch assessment',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get assessment error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch assessment',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch assessment',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get assessment error: $e');
      return ApiResponse.failure(
        e.toString(),
        error: ApiError(message: e.toString()),
      );
    }
  }

  // ===============================
  // GET ASSESSMENT HISTORY
  // ===============================
  Future<ApiResponse<AssessmentHistoryResponse>> getAssessmentHistory({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.assessmentHistory}?page=$page&limit=$limit&sortBy=$sortBy&order=$order',
      );

      if (response.data['success'] == true) {
        final historyResponse = AssessmentHistoryResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          historyResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch assessment history',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch assessment history',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get assessment history error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch assessment history',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch assessment history',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get assessment history error: $e');
      return ApiResponse.failure(
        e.toString(),
        error: ApiError(message: e.toString()),
      );
    }
  }

  // ===============================
  // GET LATEST ASSESSMENT
  // ===============================
  Future<ApiResponse<LatestAssessmentResponse>> getLatestAssessment() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.latestAssessment);

      if (response.data['success'] == true) {
        final latestResponse = LatestAssessmentResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          latestResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch latest assessment',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch latest assessment',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get latest assessment error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch latest assessment',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch latest assessment',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get latest assessment error: $e');
      return ApiResponse.failure(
        e.toString(),
        error: ApiError(message: e.toString()),
      );
    }
  }
}
