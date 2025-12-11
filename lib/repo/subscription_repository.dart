import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/subscription_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class SubscriptionRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET SUBSCRIPTION PLANS
  // ===============================
  Future<ApiResponse<SubscriptionPlansResponse>> getSubscriptionPlans() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.subscriptionPlans);

      if (response.data['success'] == true) {
        final plansResponse = SubscriptionPlansResponse.fromJson(response.data['data']);
        return ApiResponse.success(plansResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch subscription plans',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch subscription plans',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get subscription plans error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch subscription plans',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ??
              e.message ??
              'Failed to fetch subscription plans',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get subscription plans error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET CURRENT SUBSCRIPTION
  // ===============================
  Future<ApiResponse<CurrentSubscriptionResponse>> getCurrentSubscription() async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.currentSubscription);

      if (response.data['success'] == true) {
        final subscriptionResponse = CurrentSubscriptionResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          subscriptionResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch current subscription',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch current subscription',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get current subscription error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ??
            e.message ??
            'Failed to fetch current subscription',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ??
              e.message ??
              'Failed to fetch current subscription',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get current subscription error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // SUBSCRIBE TO PLAN
  // ===============================
  Future<ApiResponse<SubscribeResponse>> subscribe(SubscribeRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(ApiEndpoints.subscribe, data: request.toJson());

      if (response.data['success'] == true) {
        final subscribeResponse = SubscribeResponse.fromJson(response.data['data']);
        return ApiResponse.success(subscribeResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Subscription failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Subscription failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Subscribe error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Subscription failed',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Subscription failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Subscribe error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // CANCEL SUBSCRIPTION
  // ===============================
  Future<ApiResponse<CancelSubscriptionResponse>> cancelSubscription(
    CancelSubscriptionRequest request,
  ) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(
        ApiEndpoints.cancelSubscription,
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final cancelResponse = CancelSubscriptionResponse.fromJson(response.data['data']);
        return ApiResponse.success(cancelResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to cancel subscription',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to cancel subscription',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Cancel subscription error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to cancel subscription',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to cancel subscription',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Cancel subscription error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
