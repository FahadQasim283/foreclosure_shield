import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/support_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class SupportRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GET FAQ
  // ===============================
  Future<ApiResponse<FaqListResponse>> getFaq() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.faq);

      if (response.data['success'] == true) {
        final faqResponse = FaqListResponse.fromJson(response.data['data']);
        return ApiResponse.success(faqResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch FAQ',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch FAQ',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get FAQ error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch FAQ',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch FAQ',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get FAQ error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // CREATE SUPPORT TICKET
  // ===============================
  Future<ApiResponse<TicketResponse>> createTicket(CreateTicketRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(ApiEndpoints.createTicket, data: request.toJson());

      if (response.data['success'] == true) {
        final ticketResponse = TicketResponse.fromJson(response.data['data']);
        return ApiResponse.success(ticketResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to create ticket',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to create ticket',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Create ticket error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to create ticket',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to create ticket',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Create ticket error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET USER TICKETS
  // ===============================
  Future<ApiResponse<TicketsListResponse>> getUserTickets({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      String url = '${ApiEndpoints.supportTickets}?page=$page&limit=$limit';
      if (status != null) {
        url += '&status=$status';
      }

      final response = await _apiClient.get(url);

      if (response.data['success'] == true) {
        final ticketsResponse = TicketsListResponse.fromJson(response.data['data']);
        return ApiResponse.success(ticketsResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch tickets',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch tickets',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get user tickets error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch tickets',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch tickets',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get user tickets error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET TICKET BY ID
  // ===============================
  Future<ApiResponse<TicketResponse>> getTicketById(String ticketId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.getTicketDetails(ticketId));

      if (response.data['success'] == true) {
        final ticketResponse = TicketResponse.fromJson(response.data['data']);
        return ApiResponse.success(ticketResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch ticket',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch ticket',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get ticket error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch ticket',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch ticket',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get ticket error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // ADD MESSAGE TO TICKET
  // ===============================
  Future<ApiResponse<TicketMessageResponse>> addTicketMessage({
    required String ticketId,
    required AddTicketMessageRequest request,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(
        ApiEndpoints.addTicketMessage(ticketId),
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final messageResponse = TicketMessageResponse.fromJson(response.data['data']);
        return ApiResponse.success(messageResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to add message',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to add message',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Add ticket message error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to add message',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to add message',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Add ticket message error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // CONTACT US
  // ===============================
  Future<ApiResponse<ContactUsResponse>> contactUs(ContactUsRequest request) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.contactUs, data: request.toJson());

      if (response.data['success'] == true) {
        final contactResponse = ContactUsResponse.fromJson(response.data['data']);
        return ApiResponse.success(contactResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to send message',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to send message',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Contact us error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to send message',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to send message',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Contact us error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
