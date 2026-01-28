// ===============================
// BASE API RESPONSE
// ===============================
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final ApiError? error;

  ApiResponse({required this.success, this.message, this.data, this.error});

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse(success: true, data: data, message: message);
  }

  factory ApiResponse.failure(String message, {ApiError? error}) {
    return ApiResponse(success: false, message: message, error: error);
  }
}

// ===============================
// API ERROR
// ===============================
class ApiError {
  final String? code;
  final String message;
  final dynamic details;

  ApiError({this.code, required this.message, this.details});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String?,
      message: json['message'] as String,
      details: json['details'],
    );
  }
}

// ===============================
// PAGINATION
// ===============================
class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
    );
  }
}
