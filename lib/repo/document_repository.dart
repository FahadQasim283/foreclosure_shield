import 'package:dio/dio.dart';
import '../services/network/api_client.dart';
import '/core/constants/api_endpoints.dart';
import '../services/local_storage/token_storage.dart';
import '/data/models/document.dart';
import 'package:flutter/material.dart' show debugPrint;

class DocumentRepository {
  final ApiClient _apiClient = ApiClient();

  // ===============================
  // GENERATE LETTER
  // ===============================
  Future<Map<String, dynamic>> generateLetter({
    required String letterType,
    required String recipientName,
    required String recipientAddress,
    Map<String, dynamic>? additionalInfo,
    Map<String, dynamic>? customFields,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final data = {
        'letterType': letterType,
        'recipientName': recipientName,
        'recipientAddress': recipientAddress,
        if (additionalInfo != null) 'additionalInfo': additionalInfo,
        if (customFields != null) 'customFields': customFields,
      };

      final response = await _apiClient.post(
        ApiEndpoints.generateLetter,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final document = Document.fromJson(response['data']);
        return {'success': true, 'document': document, 'message': response['message']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Generate letter error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // UPLOAD DOCUMENT
  // ===============================
  Future<Map<String, dynamic>> uploadDocument({
    required String filePath,
    required String title,
    required String documentType,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'title': title,
        'documentType': documentType,
      });

      final response = await _apiClient.post(
        ApiEndpoints.uploadDocument,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response['success'] == true) {
        final document = Document.fromJson(response['data']);
        return {'success': true, 'document': document, 'message': response['message']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Upload document error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // GET ALL DOCUMENTS
  // ===============================
  Future<Map<String, dynamic>> getDocuments({
    int page = 1,
    int limit = 10,
    String? documentType,
    String sortBy = 'uploadedDate',
    String order = 'desc',
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      String url = '${ApiEndpoints.documents}?page=$page&limit=$limit&sortBy=$sortBy&order=$order';
      if (documentType != null) {
        url += '&documentType=$documentType';
      }

      final response = await _apiClient.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final documents = (response['data']['documents'] as List)
            .map((json) => Document.fromJson(json))
            .toList();

        return {
          'success': true,
          'documents': documents,
          'pagination': response['data']['pagination'],
        };
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get documents error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // GET DOCUMENT BY ID
  // ===============================
  Future<Map<String, dynamic>> getDocumentById(String documentId) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.get(
        '${ApiEndpoints.getDocument}/$documentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        final document = Document.fromJson(response['data']);
        return {'success': true, 'document': document};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Get document error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // DELETE DOCUMENT
  // ===============================
  Future<Map<String, dynamic>> deleteDocument(String documentId) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await _apiClient.delete(
        '${ApiEndpoints.deleteDocument}/$documentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        return {'success': true, 'message': response['message']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Delete document error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===============================
  // SHARE DOCUMENT
  // ===============================
  Future<Map<String, dynamic>> shareDocument({
    required String documentId,
    required String email,
    String? message,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final data = {'email': email, if (message != null) 'message': message};

      final response = await _apiClient.post(
        '${ApiEndpoints.shareDocument}/$documentId/share',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['success'] == true) {
        return {'success': true, 'message': response['message'], 'data': response['data']};
      }

      return {'success': false, 'message': response['error']['message']};
    } catch (e) {
      debugPrint('Share document error: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}
