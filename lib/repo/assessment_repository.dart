import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/risk_assessment.dart';
import 'package:flutter/material.dart' show debugPrint;

class AssessmentRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // CREATE ASSESSMENT
  // ===============================
  Future<Map<String, dynamic>> createAssessment({
    required double monthlyIncome,
    required double monthlyExpenses,
    required double amountOwed,
    required double propertyValue,
    required int missedPayments,
    String? additionalInfo,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.post(
        ApiEndpoints.createAssessment,
        data: {
          'monthlyIncome': monthlyIncome,
          'monthlyExpenses': monthlyExpenses,
          'amountOwed': amountOwed,
          'propertyValue': propertyValue,
          'missedPayments': missedPayments,
          if (additionalInfo != null) 'additionalInfo': additionalInfo,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final assessment = RiskAssessment.fromJson(response['data']);
        return {'success': true, 'assessment': assessment, 'message': response['message']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Create assessment error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // GET ASSESSMENT BY ID
  // ===============================
  Future<Map<String, dynamic>> getAssessmentById(String assessmentId) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.getAssessment}/$assessmentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final assessment = RiskAssessment.fromJson(response['data']);
        return {'success': true, 'assessment': assessment};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get assessment error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // GET ASSESSMENT HISTORY
  // ===============================
  Future<Map<String, dynamic>> getAssessmentHistory({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.assessmentHistory}?page=$page&limit=$limit&sortBy=$sortBy&order=$order',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final assessments = (response['data']['assessments'] as List)
            .map((json) => RiskAssessment.fromJson(json))
            .toList();

        return {
          'success': true,
          'assessments': assessments,
          'pagination': response['data']['pagination'],
        };
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get assessment history error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // GET LATEST ASSESSMENT
  // ===============================
  Future<Map<String, dynamic>> getLatestAssessment() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.get(
        ApiEndpoints.latestAssessment,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final assessment = RiskAssessment.fromJson(response['data']);
        return {'success': true, 'assessment': assessment};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get latest assessment error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
