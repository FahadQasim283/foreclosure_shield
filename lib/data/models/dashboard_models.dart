// ===============================
// DASHBOARD SUMMARY MODEL
// ===============================
class DashboardSummary {
  final RiskSummary riskSummary;
  final TasksSummary tasksSummary;
  final DocumentsSummary documentsSummary;
  final SubscriptionInfo subscriptionInfo;
  final List<RecentActivity> recentActivities;

  DashboardSummary({
    required this.riskSummary,
    required this.tasksSummary,
    required this.documentsSummary,
    required this.subscriptionInfo,
    required this.recentActivities,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      riskSummary: RiskSummary.fromJson(json['riskAssessment']),
      tasksSummary: TasksSummary.fromJson(json['actionPlan']),
      documentsSummary: DocumentsSummary.fromJson(json['documents']),
      subscriptionInfo: json['user']['subscription'] != null
          ? SubscriptionInfo.fromJson(json['user']['subscription'])
          : SubscriptionInfo(planName: 'Free', status: 'inactive', daysRemaining: 0),
      recentActivities: (json['notifications']['recent'] as List)
          .map((e) => RecentActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ===============================
// RISK SUMMARY MODEL
// ===============================
class RiskSummary {
  final String currentRiskLevel;
  final double riskScore;
  final int totalAssessments;
  final DateTime? lastAssessmentDate;

  RiskSummary({
    required this.currentRiskLevel,
    required this.riskScore,
    required this.totalAssessments,
    this.lastAssessmentDate,
  });

  factory RiskSummary.fromJson(Map<String, dynamic> json) {
    return RiskSummary(
      currentRiskLevel: json['level'] as String,
      riskScore: (json['score'] as num).toDouble(),
      totalAssessments: json['hasAssessment'] == true ? 1 : 0,
      lastAssessmentDate: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }
}

// ===============================
// TASKS SUMMARY MODEL
// ===============================
class TasksSummary {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int highPriorityTasks;
  final double completionPercentage;

  TasksSummary({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.highPriorityTasks,
    required this.completionPercentage,
  });

  factory TasksSummary.fromJson(Map<String, dynamic> json) {
    final totalTasks = json['totalTasks'] as int;
    final completedTasks = json['completedTasks'] as int;
    return TasksSummary(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      pendingTasks: totalTasks - completedTasks,
      highPriorityTasks: 0, // Not provided in API
      completionPercentage: (json['progress'] as num).toDouble(),
    );
  }
}

// ===============================
// DOCUMENTS SUMMARY MODEL
// ===============================
class DocumentsSummary {
  final int totalDocuments;
  final int generatedLetters;
  final int uploadedDocuments;
  final DateTime? lastUploadDate;

  DocumentsSummary({
    required this.totalDocuments,
    required this.generatedLetters,
    required this.uploadedDocuments,
    this.lastUploadDate,
  });

  factory DocumentsSummary.fromJson(Map<String, dynamic> json) {
    final totalCount = json['totalCount'] as int;
    return DocumentsSummary(
      totalDocuments: totalCount,
      generatedLetters: 0, // Not provided
      uploadedDocuments: totalCount,
      lastUploadDate: null, // Not provided
    );
  }
}

// ===============================
// SUBSCRIPTION INFO MODEL
// ===============================
class SubscriptionInfo {
  final String planName;
  final String status;
  final DateTime? expiryDate;
  final int daysRemaining;

  SubscriptionInfo({
    required this.planName,
    required this.status,
    this.expiryDate,
    required this.daysRemaining,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      planName: json['planName'] as String,
      status: json['status'] as String,
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate'] as String) : null,
      daysRemaining: json['daysRemaining'] as int,
    );
  }
}

// ===============================
// RECENT ACTIVITY MODEL
// ===============================
class RecentActivity {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;
  final String? icon;

  RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.icon,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      icon: json['icon'] as String?,
    );
  }
}

// ===============================
// DASHBOARD STATISTICS MODEL
// ===============================
class DashboardStatistics {
  final Map<String, int> assessmentsByMonth;
  final Map<String, int> tasksByCategory;
  final Map<String, int> documentsByType;
  final List<MonthlyProgress> monthlyProgress;

  DashboardStatistics({
    required this.assessmentsByMonth,
    required this.tasksByCategory,
    required this.documentsByType,
    required this.monthlyProgress,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    return DashboardStatistics(
      assessmentsByMonth: Map<String, int>.from(json['assessmentsByMonth'] as Map),
      tasksByCategory: Map<String, int>.from(json['tasksByCategory'] as Map),
      documentsByType: Map<String, int>.from(json['documentsByType'] as Map),
      monthlyProgress: (json['monthlyProgress'] as List)
          .map((e) => MonthlyProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ===============================
// MONTHLY PROGRESS MODEL
// ===============================
class MonthlyProgress {
  final String month;
  final int assessments;
  final int completedTasks;
  final int documents;

  MonthlyProgress({
    required this.month,
    required this.assessments,
    required this.completedTasks,
    required this.documents,
  });

  factory MonthlyProgress.fromJson(Map<String, dynamic> json) {
    return MonthlyProgress(
      month: json['month'] as String,
      assessments: json['assessments'] as int,
      completedTasks: json['completedTasks'] as int,
      documents: json['documents'] as int,
    );
  }
}

// ===============================
// RESPONSE MODELS
// ===============================

class DashboardSummaryResponse {
  final DashboardSummary dashboard;

  DashboardSummaryResponse({required this.dashboard});

  factory DashboardSummaryResponse.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryResponse(dashboard: DashboardSummary.fromJson(json));
  }
}

class DashboardStatisticsResponse {
  final DashboardStatistics statistics;

  DashboardStatisticsResponse({required this.statistics});

  factory DashboardStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardStatisticsResponse(statistics: DashboardStatistics.fromJson(json));
  }
}
