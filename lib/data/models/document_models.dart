import '/data/models/document.dart';
import '/data/models/api_response.dart';

// ===============================
// DOCUMENT REQUEST MODELS
// ===============================

class GenerateLetterRequest {
  final String letterType;
  final String recipientName;
  final String recipientAddress;
  final Map<String, dynamic>? additionalInfo;
  final Map<String, dynamic>? customFields;

  GenerateLetterRequest({
    required this.letterType,
    required this.recipientName,
    required this.recipientAddress,
    this.additionalInfo,
    this.customFields,
  });

  Map<String, dynamic> toJson() {
    return {
      'letterType': letterType,
      'recipientName': recipientName,
      'recipientAddress': recipientAddress,
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
      if (customFields != null) 'customFields': customFields,
    };
  }
}

class ShareDocumentRequest {
  final String email;
  final String? message;

  ShareDocumentRequest({required this.email, this.message});

  Map<String, dynamic> toJson() {
    return {'email': email, if (message != null) 'message': message};
  }
}

// ===============================
// DOCUMENT RESPONSE MODELS
// ===============================

class DocumentResponse {
  final Document document;

  DocumentResponse({required this.document});

  factory DocumentResponse.fromJson(Map<String, dynamic> json) {
    return DocumentResponse(document: Document.fromJson(json));
  }
}

class DocumentsListResponse {
  final List<Document> documents;
  final Pagination pagination;

  DocumentsListResponse({required this.documents, required this.pagination});

  factory DocumentsListResponse.fromJson(Map<String, dynamic> json) {
    return DocumentsListResponse(
      documents: (json['documents'] as List)
          .map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class ShareDocumentResponse {
  final String sharedWith;
  final DateTime sharedAt;

  ShareDocumentResponse({required this.sharedWith, required this.sharedAt});

  factory ShareDocumentResponse.fromJson(Map<String, dynamic> json) {
    return ShareDocumentResponse(
      sharedWith: json['sharedWith'] as String,
      sharedAt: DateTime.parse(json['sharedAt'] as String),
    );
  }
}
