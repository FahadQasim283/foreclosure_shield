import 'package:dio/dio.dart';

class ErrorHandler {
  /// Extracts a user-friendly error message from DioException
  /// Returns only the backend message, not the full exception details
  static String getErrorMessage(dynamic error, [String defaultMessage = 'An error occurred']) {
    if (error is DioException) {
      // Try to extract message from response data
      if (error.response?.data != null) {
        try {
          final data = error.response!.data;

          // Check for various possible message fields
          if (data is Map) {
            // Direct message field
            if (data['message'] != null) {
              return data['message'].toString();
            }

            // Error object with message
            if (data['error'] != null && data['error'] is Map) {
              if (data['error']['message'] != null) {
                return data['error']['message'].toString();
              }
            }

            // Detail field (common in some APIs)
            if (data['detail'] != null) {
              return data['detail'].toString();
            }
          }

          // If data is a string
          if (data is String && data.isNotEmpty) {
            return data;
          }
        } catch (_) {
          // Fall through to default handling
        }
      }

      // Handle specific DioException types with user-friendly messages
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.connectionError:
          return 'Unable to connect to server. Please check your internet connection.';
        case DioExceptionType.badResponse:
          return defaultMessage; // Use default if we couldn't extract message
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return defaultMessage;
      }
    }

    // For non-DioException errors
    return defaultMessage;
  }
}
