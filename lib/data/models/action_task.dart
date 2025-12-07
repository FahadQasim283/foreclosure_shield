class ActionTask {
  final String id;
  final String assessmentId;
  final String title;
  final String description;
  final String category; // 'immediate', 'urgent', 'important', 'optional'
  final String priority; // 'high', 'medium', 'low'
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? completedDate;
  final int sortOrder;

  ActionTask({
    required this.id,
    required this.assessmentId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
    this.completedDate,
    required this.sortOrder,
  });

  factory ActionTask.fromJson(Map<String, dynamic> json) {
    return ActionTask(
      id: json['id'] as String,
      assessmentId: json['assessment_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      priority: json['priority'] as String,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'] as String)
          : null,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment_id': assessmentId,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'is_completed': isCompleted,
      'completed_date': completedDate?.toIso8601String(),
      'sort_order': sortOrder,
    };
  }

  ActionTask copyWith({
    String? id,
    String? assessmentId,
    String? title,
    String? description,
    String? category,
    String? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedDate,
    int? sortOrder,
  }) {
    return ActionTask(
      id: id ?? this.id,
      assessmentId: assessmentId ?? this.assessmentId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
