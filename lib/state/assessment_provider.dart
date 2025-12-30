import 'package:flutter/foundation.dart';
import '../data/models/assessment_models.dart';
import '../data/models/risk_assessment.dart';
import '../repo/assessment_repository.dart';
import '../core/utils/error_handler.dart';

enum AssessmentState { idle, loading, success, error }

class AssessmentProvider extends ChangeNotifier {
  final AssessmentRepository _assessmentRepository = AssessmentRepository();

  AssessmentState _state = AssessmentState.idle;
  RiskAssessment? _currentAssessment;
  RiskAssessment? _latestAssessment;
  List<RiskAssessment> _assessmentHistory = [];
  String? _errorMessage;

  // Getters
  AssessmentState get state => _state;
  RiskAssessment? get currentAssessment => _currentAssessment;
  RiskAssessment? get latestAssessment => _latestAssessment;
  List<RiskAssessment> get assessmentHistory => _assessmentHistory;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AssessmentState.loading;
  bool get hasError => _state == AssessmentState.error;
  bool get hasAssessment => _currentAssessment != null || _latestAssessment != null;

  // Create Assessment
  Future<RiskAssessment?> createAssessment(CreateAssessmentRequest request) async {
    _setState(AssessmentState.loading);
    _errorMessage = null;

    try {
      final response = await _assessmentRepository.createAssessment(request);

      if (response.success && response.data != null) {
        _currentAssessment = response.data!.assessment;
        _latestAssessment = response.data!.assessment;
        _setState(AssessmentState.success);
        return _currentAssessment;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to create assessment';
        _setState(AssessmentState.error);
        return null;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to create assessment');
      _setState(AssessmentState.error);
      return null;
    }
  }

  // Get Assessment by ID
  Future<bool> getAssessmentById(String assessmentId) async {
    _setState(AssessmentState.loading);
    _errorMessage = null;

    try {
      final response = await _assessmentRepository.getAssessmentById(assessmentId);

      if (response.success && response.data != null) {
        _currentAssessment = response.data!.assessment;
        _setState(AssessmentState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch assessment';
        _setState(AssessmentState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to fetch assessment');
      _setState(AssessmentState.error);
      return false;
    }
  }

  // Get Assessment History
  Future<bool> getAssessmentHistory({int page = 1, int limit = 10}) async {
    _setState(AssessmentState.loading);
    _errorMessage = null;

    try {
      final response = await _assessmentRepository.getAssessmentHistory(page: page, limit: limit);

      if (response.success && response.data != null) {
        if (page == 1) {
          _assessmentHistory = response.data!.assessments;
        } else {
          _assessmentHistory.addAll(response.data!.assessments);
        }
        _setState(AssessmentState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch history';
        _setState(AssessmentState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to fetch history');
      _setState(AssessmentState.error);
      return false;
    }
  }

  // Get Latest Assessment
  Future<bool> getLatestAssessment() async {
    _setState(AssessmentState.loading);
    _errorMessage = null;

    try {
      final response = await _assessmentRepository.getLatestAssessment();

      if (response.success && response.data != null) {
        _latestAssessment = response.data!.assessment;
        _currentAssessment = response.data!.assessment;
        _setState(AssessmentState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'No assessments found';
        _setState(AssessmentState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'No assessments found');
      _setState(AssessmentState.error);
      return false;
    }
  }

  // Refresh latest assessment (silent)
  Future<void> refreshLatest() async {
    try {
      final response = await _assessmentRepository.getLatestAssessment();
      if (response.success && response.data != null) {
        _latestAssessment = response.data!.assessment;
        _currentAssessment = response.data!.assessment;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear current assessment
  void clearCurrent() {
    _currentAssessment = null;
    notifyListeners();
  }

  // Clear all data
  void clear() {
    _currentAssessment = null;
    _latestAssessment = null;
    _assessmentHistory = [];
    _errorMessage = null;
    _setState(AssessmentState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AssessmentState.error) {
      _setState(AssessmentState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(AssessmentState newState) {
    _state = newState;
    notifyListeners();
  }
}
