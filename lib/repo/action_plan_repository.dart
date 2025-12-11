import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/action_task.dart';
import 'package:flutter/material.dart' show debugPrint;

class ActionPlanRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET ACTION PLAN
  // ===============================
  Future<Map<String, dynamic>> getActionPlan({String? assessmentId}) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      String url = ApiEndpoints.actionPlan;
      if (assessmentId != null) {
        url += '?assessmentId=$assessmentId';
      }

      final response = await _apiClient.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final tasks = (response['data']['tasks'] as List)
            .map((json) => ActionTask.fromJson(json))
            .toList();

        return {
          'success': true,
          'tasks': tasks,
          'progress': response['data']['progress'],
          'actionPlanId': response['data']['id'],
        };
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get action plan error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // GET TASK DETAILS
  // ===============================
  Future<Map<String, dynamic>> getTaskDetails(String taskId) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.taskDetails}/$taskId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final task = ActionTask.fromJson(response['data']);
        return {'success': true, 'task': task};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get task details error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // UPDATE TASK STATUS
  // ===============================
  Future<Map<String, dynamic>> updateTaskStatus({
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.patch(
        '${ApiEndpoints.updateTaskStatus}/$taskId/status',
        data: {'isCompleted': isCompleted},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        return {'success': true, 'message': response['message'], 'data': response['data']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Update task status error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // UPDATE TASK NOTES
  // ===============================
  Future<Map<String, dynamic>> updateTaskNotes({
    required String taskId,
    required String notes,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.patch(
        '${ApiEndpoints.updateTaskNotes}/$taskId/notes',
        data: {'notes': notes},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        return {'success': true, 'message': response['message'], 'data': response['data']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Update task notes error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // GET TASKS BY CATEGORY
  // ===============================
  Future<Map<String, dynamic>> getTasksByCategory(String category) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.tasksByCategory}/$category',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final tasks = (response['data']['tasks'] as List)
            .map((json) => ActionTask.fromJson(json))
            .toList();

        return {'success': true, 'category': response['data']['category'], 'tasks': tasks};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get tasks by category error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
