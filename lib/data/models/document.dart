class Document {
  final String id;
  final String userId;
  final String? assessmentId;
  final String title;
  final String documentType; // 'letter', 'notice', 'uploaded', 'generated'
  final String? fileUrl;
  final String? fileType; // 'pdf', 'docx', 'jpg', 'png'
  final int? fileSizeBytes;
  final DateTime uploadedDate;
  final String? generatedContent; // For AI-generated documents
  final String? letterType; // 'hardship', 'loan_modification', 'reinstatement', 'cease_desist'

  Document({
    required this.id,
    required this.userId,
    this.assessmentId,
    required this.title,
    required this.documentType,
    this.fileUrl,
    this.fileType,
    this.fileSizeBytes,
    required this.uploadedDate,
    this.generatedContent,
    this.letterType,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      assessmentId: json['assessment_id'] as String?,
      title: json['title'] as String,
      documentType: json['document_type'] as String,
      fileUrl: json['file_url'] as String?,
      fileType: json['file_type'] as String?,
      fileSizeBytes: json['file_size_bytes'] as int?,
      uploadedDate: DateTime.parse(json['uploaded_date'] as String),
      generatedContent: json['generated_content'] as String?,
      letterType: json['letter_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'assessment_id': assessmentId,
      'title': title,
      'document_type': documentType,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size_bytes': fileSizeBytes,
      'uploaded_date': uploadedDate.toIso8601String(),
      'generated_content': generatedContent,
      'letter_type': letterType,
    };
  }

  String get fileSizeFormatted {
    if (fileSizeBytes == null) return 'Unknown';
    if (fileSizeBytes! < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes! < 1048576) {
      return '${(fileSizeBytes! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes! / 1048576).toStringAsFixed(1)} MB';
  }
}
