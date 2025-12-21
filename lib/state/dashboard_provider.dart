import 'package:flutter/foundation.dart';
import '../data/models/api_response.dart';
import '../data/models/dashboard_models.dart';
import '../repo/dashboard_repository.dart';

enum DashboardState { idle, loading, success, error }

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _dashboardRepository = DashboardRepository();

  DashboardState _state = DashboardState.idle;
  DashboardSummary? _summary;
  DashboardStatistics? _statistics;
  String? _errorMessage;

  // Getters
  DashboardState get state => _state;
  DashboardSummary? get summary => _summary;
  DashboardStatistics? get statistics => _statistics;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == DashboardState.loading;
  bool get hasError => _state == DashboardState.error;
  bool get hasSummary => _summary != null;
  bool get hasStatistics => _statistics != null;

  // Computed getters from summary
  String? get currentRiskLevel => _summary?.riskSummary.currentRiskLevel;
  int? get riskScore => _summary?.riskSummary.riskScore.toInt();
  int? get totalTasks => _summary?.tasksSummary.totalTasks;
  int? get completedTasks => _summary?.tasksSummary.completedTasks;
  double? get taskCompletionPercentage => _summary?.tasksSummary.completionPercentage;
  int? get totalDocuments => _summary?.documentsSummary.totalDocuments;
  String? get subscriptionPlan => _summary?.subscriptionInfo.planName;
  int? get subscriptionDaysRemaining => _summary?.subscriptionInfo.daysRemaining;

  // Get Dashboard Summary
  Future<bool> getDashboardSummary() async {
    _setState(DashboardState.loading);
    _errorMessage = null;

    try {
      final response = await _dashboardRepository.getDashboardSummary();

      if (response.success && response.data != null) {
        _summary = response.data!.dashboard;
        _setState(DashboardState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch dashboard summary';
        _setState(DashboardState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(DashboardState.error);
      return false;
    }
  }

  // Get Dashboard Statistics
  Future<bool> getDashboardStatistics() async {
    _setState(DashboardState.loading);
    _errorMessage = null;

    try {
      final response = await _dashboardRepository.getDashboardStatistics();

      if (response.success && response.data != null) {
        _statistics = response.data!.statistics;
        _setState(DashboardState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch statistics';
        _setState(DashboardState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(DashboardState.error);
      return false;
    }
  }

  // Get Both Summary and Statistics
  Future<bool> getDashboardData() async {
    _setState(DashboardState.loading);
    _errorMessage = null;

    try {
      // Fetch both in parallel
      final results = await Future.wait([
        _dashboardRepository.getDashboardSummary(),
        _dashboardRepository.getDashboardStatistics(),
      ]);

      final summaryResponse = results[0] as ApiResponse<DashboardSummaryResponse>;
      final statsResponse = results[1] as ApiResponse<DashboardStatisticsResponse>;

      if (summaryResponse.success && summaryResponse.data != null) {
        _summary = summaryResponse.data!.dashboard;
      }

      if (statsResponse.success && statsResponse.data != null) {
        _statistics = statsResponse.data!.statistics;
      }

      if (summaryResponse.success || statsResponse.success) {
        _setState(DashboardState.success);
        return true;
      } else {
        _errorMessage = 'Failed to fetch dashboard data';
        _setState(DashboardState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(DashboardState.error);
      return false;
    }
  }

  // Get recent activities
  List<RecentActivity> getRecentActivities({int limit = 5}) {
    if (_summary == null) return [];
    return _summary!.recentActivities.take(limit).toList();
  }

  // Get monthly progress data
  List<MonthlyProgress> getMonthlyProgress() {
    if (_statistics == null) return [];
    return _statistics!.monthlyProgress;
  }

  // Get assessments by month
  Map<String, int> getAssessmentsByMonth() {
    if (_statistics == null) return {};
    return _statistics!.assessmentsByMonth;
  }

  // Get tasks by category
  Map<String, int> getTasksByCategory() {
    if (_statistics == null) return {};
    return _statistics!.tasksByCategory;
  }

  // Get documents by type
  Map<String, int> getDocumentsByType() {
    if (_statistics == null) return {};
    return _statistics!.documentsByType;
  }

  // Check if at risk
  bool get isAtRisk {
    if (_summary == null) return false;
    final riskLevel = _summary!.riskSummary.currentRiskLevel.toLowerCase();
    return riskLevel == 'high' || riskLevel == 'critical';
  }

  // Check if subscription is expiring soon
  bool get isSubscriptionExpiringSoon {
    if (_summary == null) return false;
    final daysRemaining = _summary!.subscriptionInfo.daysRemaining;
    return daysRemaining <= 7 && daysRemaining > 0;
  }

  // Refresh dashboard data (silent)
  Future<void> refreshDashboard() async {
    try {
      final results = await Future.wait([
        _dashboardRepository.getDashboardSummary(),
        _dashboardRepository.getDashboardStatistics(),
      ]);

      final summaryResponse = results[0] as ApiResponse<DashboardSummaryResponse>;
      final statsResponse = results[1] as ApiResponse<DashboardStatisticsResponse>;

      if (summaryResponse.success && summaryResponse.data != null) {
        _summary = summaryResponse.data!.dashboard;
      }

      if (statsResponse.success && statsResponse.data != null) {
        _statistics = statsResponse.data!.statistics;
      }

      notifyListeners();
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _summary = null;
    _statistics = null;
    _errorMessage = null;
    _setState(DashboardState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == DashboardState.error) {
      _setState(DashboardState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(DashboardState newState) {
    _state = newState;
    notifyListeners();
  }
}
