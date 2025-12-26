import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/action_plan_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class ActionPlanRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET ACTION PLAN
  // ===============================
  Future<ApiResponse<ActionPlanResponse>> getActionPlan({String? assessmentId}) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      String url = ApiEndpoints.actionPlan;
      if (assessmentId != null) {
        url += '?assessmentId=$assessmentId';
      }

      final response = await _apiClient.get(url);

      if (response.data['success'] == true) {
        final actionPlanResponse = ActionPlanResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          actionPlanResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch action plan',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch action plan',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get action plan error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch action plan',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch action plan',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get action plan error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET TASK DETAILS
  // ===============================
  Future<ApiResponse<TaskDetailsResponse>> getTaskDetails(String taskId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.getTaskDetails(taskId));

      if (response.data['success'] == true) {
        final taskResponse = TaskDetailsResponse.fromJson(response.data['data']);
        return ApiResponse.success(taskResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch task details',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch task details',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get task details error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch task details',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch task details',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get task details error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPDATE TASK STATUS
  // ===============================
  Future<ApiResponse<UpdateTaskStatusResponse>> updateTaskStatus({
    required String taskId,
    required UpdateTaskStatusRequest request,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.patch(
        ApiEndpoints.updateTaskStatus(taskId),
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final statusResponse = UpdateTaskStatusResponse.fromJson(response.data['data']);
        return ApiResponse.success(statusResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to update task status',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to update task status',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Update task status error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to update task status',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to update task status',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Update task status error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPDATE TASK NOTES
  // ===============================
  Future<ApiResponse<UpdateTaskNotesResponse>> updateTaskNotes({
    required String taskId,
    required UpdateTaskNotesRequest request,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.patch(
        ApiEndpoints.updateTaskNotes(taskId),
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final notesResponse = UpdateTaskNotesResponse.fromJson(response.data['data']);
        return ApiResponse.success(notesResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to update task notes',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to update task notes',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Update task notes error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to update task notes',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to update task notes',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Update task notes error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET ALL TASKS
  // ===============================
  Future<ApiResponse<ActionPlanResponse>> getAllTasks() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.allTasks);

      if (response.data['success'] == true) {
        final tasksResponse = ActionPlanResponse.fromJson(response.data['data']);
        return ApiResponse.success(tasksResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch tasks',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch tasks',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get all tasks error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch tasks',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch tasks',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get all tasks error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
