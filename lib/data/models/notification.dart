class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'alert', 'reminder', 'info', 'success'
  final DateTime createdAt;
  final bool isRead;
  final DateTime? readAt;
  final String? relatedAssessmentId;
  final String? actionUrl;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.readAt,
    this.relatedAssessmentId,
    this.actionUrl,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      relatedAssessmentId: json['related_assessment_id'] as String?,
      actionUrl: json['action_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'related_assessment_id': relatedAssessmentId,
      'action_url': actionUrl,
    };
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isRead,
    DateTime? readAt,
    String? relatedAssessmentId,
    String? actionUrl,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      relatedAssessmentId: relatedAssessmentId ?? this.relatedAssessmentId,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}
