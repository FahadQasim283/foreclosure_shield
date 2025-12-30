import '/data/models/action_task.dart';

// ===============================
// ACTION PLAN REQUEST MODELS
// ===============================

class UpdateTaskStatusRequest {
  final bool isCompleted;

  UpdateTaskStatusRequest({required this.isCompleted});

  Map<String, dynamic> toJson() {
    return {'isCompleted': isCompleted};
  }
}

class UpdateTaskNotesRequest {
  final String notes;

  UpdateTaskNotesRequest({required this.notes});

  Map<String, dynamic> toJson() {
    return {'notes': notes};
  }
}

// ===============================
// ACTION PLAN RESPONSE MODELS
// ===============================

class ActionPlanProgress {
  final int totalTasks;
  final int completedTasks;
  final double percentage;

  ActionPlanProgress({
    required this.totalTasks,
    required this.completedTasks,
    required this.percentage,
  });

  factory ActionPlanProgress.fromJson(Map<String, dynamic> json) {
    return ActionPlanProgress(
      totalTasks: int.parse(json['totalTasks'].toString()),
      completedTasks: int.parse(json['completedTasks'].toString()),
      percentage: double.parse(json['percentage'].toString()),
    );
  }
}

class ActionPlanResponse {
  final String actionPlanId;
  final List<ActionTask> tasks;
  final ActionPlanProgress progress;

  ActionPlanResponse({required this.actionPlanId, required this.tasks, required this.progress});

  factory ActionPlanResponse.fromJson(Map<String, dynamic> json) {
    return ActionPlanResponse(
      actionPlanId: json['id'] ?? '',
      tasks: (json['tasks'] as List)
          .map((e) => ActionTask.fromJson(e as Map<String, dynamic>))
          .toList(),
      progress: ActionPlanProgress.fromJson(json['progress']),
    );
  }
}

class TaskDetailsResponse {
  final ActionTask task;

  TaskDetailsResponse({required this.task});

  factory TaskDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TaskDetailsResponse(task: ActionTask.fromJson(json));
  }
}

class UpdateTaskStatusResponse {
  final String id;
  final bool isCompleted;
  final DateTime? completedDate;
  final DateTime updatedAt;

  UpdateTaskStatusResponse({
    required this.id,
    required this.isCompleted,
    this.completedDate,
    required this.updatedAt,
  });

  factory UpdateTaskStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTaskStatusResponse(
      id: json['id'] ?? '',
      isCompleted: json['isCompleted'] == 'true',
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class UpdateTaskNotesResponse {
  final String id;
  final String notes;
  final DateTime updatedAt;

  UpdateTaskNotesResponse({required this.id, required this.notes, required this.updatedAt});

  factory UpdateTaskNotesResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTaskNotesResponse(
      id: json['id'] as String,
      notes: json['notes'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class TasksByCategoryResponse {
  final String category;
  final List<ActionTask> tasks;

  TasksByCategoryResponse({required this.category, required this.tasks});

  factory TasksByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return TasksByCategoryResponse(
      category: json['category'] as String,
      tasks: (json['tasks'] as List)
          .map((e) => ActionTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
