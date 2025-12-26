import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/api_response.dart';
import '/data/models/document_models.dart';
import 'package:flutter/material.dart' show debugPrint;

class DocumentRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GENERATE LETTER
  // ===============================
  Future<ApiResponse<DocumentResponse>> generateLetter(GenerateLetterRequest request) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.post(ApiEndpoints.generateDocument, data: request.toJson());

      if (response.data['success'] == true) {
        final documentResponse = DocumentResponse.fromJson(response.data['data']);
        return ApiResponse.success(documentResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Letter generation failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Letter generation failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Generate letter error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Letter generation failed',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Letter generation failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Generate letter error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // UPLOAD DOCUMENT
  // ===============================
  Future<ApiResponse<DocumentResponse>> uploadDocument({
    required String filePath,
    required String title,
    required String documentType,
    Function(double)? onProgress,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'title': title,
        'documentType': documentType,
      });

      final response = await _apiClient.post(ApiEndpoints.uploadDocument, data: formData);

      if (response.data['success'] == true) {
        final documentResponse = DocumentResponse.fromJson(response.data['data']);
        return ApiResponse.success(documentResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Document upload failed',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Document upload failed',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Upload document error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Document upload failed',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Document upload failed',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Upload document error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET ALL DOCUMENTS
  // ===============================
  Future<ApiResponse<DocumentsListResponse>> getDocuments({
    int page = 1,
    int limit = 10,
    String? documentType,
    String sortBy = 'uploadedDate',
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

      String url = '${ApiEndpoints.documents}?page=$page&limit=$limit&sortBy=$sortBy&order=$order';
      if (documentType != null) {
        url += '&documentType=$documentType';
      }

      final response = await _apiClient.get(url);

      if (response.data['success'] == true) {
        final documentsListResponse = DocumentsListResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          documentsListResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch documents',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch documents',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get documents error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch documents',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch documents',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get documents error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // LIST DOCUMENTS
  // ===============================
  Future<ApiResponse<DocumentsListResponse>> listDocuments({
    int page = 1,
    int limit = 20,
    String? documentType,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (documentType != null) 'type': documentType,
      };

      final queryString = queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      final url = '${ApiEndpoints.documents}?$queryString';

      final response = await _apiClient.get(url);

      if (response.data['success'] == true) {
        final documentsListResponse = DocumentsListResponse.fromJson(response.data['data']);
        return ApiResponse.success(
          documentsListResponse,
          message: response.data['message'] as String?,
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch documents',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch documents',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('List documents error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch documents',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch documents',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('List documents error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET DOCUMENT BY ID
  // ===============================
  Future<ApiResponse<DocumentResponse>> getDocumentById(String documentId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.get(ApiEndpoints.getDocument(documentId));

      if (response.data['success'] == true) {
        final documentResponse = DocumentResponse.fromJson(response.data['data']);
        return ApiResponse.success(documentResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to fetch document',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to fetch document',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Get document error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch document',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to fetch document',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Get document error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // GET DOCUMENT (alias for backward compatibility)
  // ===============================
  Future<ApiResponse<DocumentResponse>> getDocument(String documentId) {
    return getDocumentById(documentId);
  }

  // ===============================
  // DOWNLOAD DOCUMENT
  // ===============================
  Future<ApiResponse<String>> downloadDocument({
    required String documentId,
    required String savePath,
    Function(double)? onProgress,
  }) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      await _apiClient.dio.download(
        ApiEndpoints.downloadDocument(documentId),
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return ApiResponse.success(savePath, message: 'Document downloaded successfully');
    } on DioException catch (e) {
      debugPrint('Download document error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to download document',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to download document',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Download document error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // DELETE DOCUMENT
  // ===============================
  Future<ApiResponse<void>> deleteDocument(String documentId) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null) {
        return ApiResponse.failure(
          'No authentication token',
          error: ApiError(message: 'No authentication token'),
        );
      }

      final response = await _apiClient.delete(ApiEndpoints.deleteDocument(documentId));

      if (response.data['success'] == true) {
        return ApiResponse.success(
          null,
          message: response.data['message'] as String? ?? 'Document deleted successfully',
        );
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to delete document',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to delete document',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Delete document error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to delete document',
        error: ApiError(
          message:
              e.response?.data['error']?['message'] ?? e.message ?? 'Failed to delete document',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Delete document error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }

  // ===============================
  // SHARE DOCUMENT
  // ===============================
  Future<ApiResponse<ShareDocumentResponse>> shareDocument({
    required String documentId,
    required ShareDocumentRequest request,
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
        ApiEndpoints.shareDocument(documentId),
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        final shareResponse = ShareDocumentResponse.fromJson(response.data['data']);
        return ApiResponse.success(shareResponse, message: response.data['message'] as String?);
      }

      return ApiResponse.failure(
        response.data['error']?['message'] ?? 'Failed to share document',
        error: ApiError(
          message: response.data['error']?['message'] ?? 'Failed to share document',
          code: response.statusCode?.toString(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('Share document error: $e');
      return ApiResponse.failure(
        e.response?.data['error']?['message'] ?? e.message ?? 'Failed to share document',
        error: ApiError(
          message: e.response?.data['error']?['message'] ?? e.message ?? 'Failed to share document',
          code: e.response?.statusCode?.toString(),
        ),
      );
    } catch (e) {
      debugPrint('Share document error: $e');
      return ApiResponse.failure(e.toString(), error: ApiError(message: e.toString()));
    }
  }
}
