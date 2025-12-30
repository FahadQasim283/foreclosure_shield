import 'package:flutter/foundation.dart';
import '../data/models/document_models.dart';
import '../data/models/document.dart';
import '../repo/document_repository.dart';
import '../core/utils/error_handler.dart';

enum DocumentState { idle, loading, success, error }

class DocumentProvider extends ChangeNotifier {
  final DocumentRepository _documentRepository = DocumentRepository();

  DocumentState _state = DocumentState.idle;
  List<Document> _documents = [];
  Document? _currentDocument;
  String? _errorMessage;
  double _uploadProgress = 0.0;
  double _downloadProgress = 0.0;

  // Getters
  DocumentState get state => _state;
  List<Document> get documents => _documents;
  Document? get currentDocument => _currentDocument;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  double get downloadProgress => _downloadProgress;
  bool get isLoading => _state == DocumentState.loading;
  bool get hasError => _state == DocumentState.error;
  bool get hasDocuments => _documents.isNotEmpty;

  // Computed getters
  List<Document> get generatedDocuments =>
      _documents.where((d) => d.documentType == 'GENERATED').toList();
  List<Document> get uploadedDocuments =>
      _documents.where((d) => d.documentType == 'UPLOADED').toList();

  // Generate Letter
  Future<Document?> generateLetter(GenerateLetterRequest request) async {
    _setState(DocumentState.loading);
    _errorMessage = null;

    try {
      final response = await _documentRepository.generateLetter(request);

      if (response.success && response.data != null) {
        final newDocument = response.data!.document;
        _documents.insert(0, newDocument);
        _currentDocument = newDocument;
        _setState(DocumentState.success);
        return newDocument;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to generate letter';
        _setState(DocumentState.error);
        return null;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to generate letter');
      _setState(DocumentState.error);
      return null;
    }
  }

  // Upload Document
  Future<Document?> uploadDocument({
    required String filePath,
    required String title,
    required String documentType,
  }) async {
    _setState(DocumentState.loading);
    _errorMessage = null;
    _uploadProgress = 0.0;

    try {
      final response = await _documentRepository.uploadDocument(
        filePath: filePath,
        title: title,
        documentType: documentType,
        onProgress: (progress) {
          _uploadProgress = progress;
          notifyListeners();
        },
      );

      if (response.success && response.data != null) {
        final newDocument = response.data!.document;
        _documents.insert(0, newDocument);
        _uploadProgress = 1.0;
        _setState(DocumentState.success);
        return newDocument;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to upload document';
        _uploadProgress = 0.0;
        _setState(DocumentState.error);
        return null;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to upload document');
      _uploadProgress = 0.0;
      _setState(DocumentState.error);
      return null;
    }
  }

  // List Documents
  Future<bool> listDocuments({int page = 1, int limit = 20, String? documentType}) async {
    _setState(DocumentState.loading);
    _errorMessage = null;

    try {
      final response = await _documentRepository.listDocuments(
        page: page,
        limit: limit,
        documentType: documentType,
      );

      if (response.success && response.data != null) {
        if (page == 1) {
          _documents = response.data!.documents;
        } else {
          _documents.addAll(response.data!.documents);
        }
        _setState(DocumentState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch documents';
        _setState(DocumentState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to fetch documents');
      _setState(DocumentState.error);
      return false;
    }
  }

  // Get Document by ID
  Future<bool> getDocumentById(String documentId) async {
    _setState(DocumentState.loading);
    _errorMessage = null;

    try {
      final response = await _documentRepository.getDocument(documentId);

      if (response.success && response.data != null) {
        _currentDocument = response.data!.document;

        // Update in list if exists
        final index = _documents.indexWhere((d) => d.id == documentId);
        if (index != -1) {
          _documents[index] = _currentDocument!;
        }

        _setState(DocumentState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch document';
        _setState(DocumentState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to fetch document');
      _setState(DocumentState.error);
      return false;
    }
  }

  // Download Document
  Future<String?> downloadDocument(String documentId, String savePath) async {
    _downloadProgress = 0.0;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _documentRepository.downloadDocument(
        documentId: documentId,
        savePath: savePath,
        onProgress: (progress) {
          _downloadProgress = progress;
          notifyListeners();
        },
      );

      if (response.success && response.data != null) {
        _downloadProgress = 1.0;
        notifyListeners();
        return response.data; // response.data is the savePath String
      } else {
        _errorMessage = response.error?.message ?? 'Failed to download document';
        _downloadProgress = 0.0;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to download document');
      _downloadProgress = 0.0;
      notifyListeners();
      return null;
    }
  }

  // Delete Document
  Future<bool> deleteDocument(String documentId) async {
    _errorMessage = null;

    // Optimistic delete
    final deletedDoc = _documents.firstWhere(
      (d) => d.id == documentId,
      orElse: () => _documents.first,
    );
    _documents.removeWhere((d) => d.id == documentId);
    notifyListeners();

    try {
      final response = await _documentRepository.deleteDocument(documentId);

      if (response.success) {
        return true;
      } else {
        // Revert delete
        _documents.add(deletedDoc);
        _errorMessage = response.error?.message ?? 'Failed to delete document';
        notifyListeners();
        return false;
      }
    } catch (e) {
      // Revert delete
      _documents.add(deletedDoc);
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to delete document');
      notifyListeners();
      return false;
    }
  }

  // Share Document
  Future<bool> shareDocument(String documentId, String email) async {
    _errorMessage = null;

    try {
      final response = await _documentRepository.shareDocument(
        documentId: documentId,
        request: ShareDocumentRequest(email: email),
      );

      if (response.success) {
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to share document';
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to share document');
      return false;
    }
  }

  // Get documents by type
  List<Document> getDocumentsByType(String type) {
    return _documents.where((d) => d.documentType == type).toList();
  }

  // Refresh documents (silent)
  Future<void> refreshDocuments() async {
    try {
      final response = await _documentRepository.listDocuments();
      if (response.success && response.data != null) {
        _documents = response.data!.documents;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _documents = [];
    _currentDocument = null;
    _errorMessage = null;
    _uploadProgress = 0.0;
    _downloadProgress = 0.0;
    _setState(DocumentState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == DocumentState.error) {
      _setState(DocumentState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(DocumentState newState) {
    _state = newState;
    notifyListeners();
  }
}
