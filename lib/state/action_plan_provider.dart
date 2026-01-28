import 'package:flutter/foundation.dart';
import '../data/models/action_plan_models.dart';
import '../data/models/action_task.dart';
import '../repo/action_plan_repository.dart';
import '../core/utils/error_handler.dart';

enum ActionPlanState { idle, loading, success, error }

class ActionPlanProvider extends ChangeNotifier {
  final ActionPlanRepository _actionPlanRepository = ActionPlanRepository();

  ActionPlanState _state = ActionPlanState.idle;
  ActionPlanResponse? _actionPlan;
  ActionTask? _currentTask;
  List<ActionTask> _tasksByCategory = [];
  String? _errorMessage;

  // Task completion tracking
  Map<String, bool> _taskCompletionStates = {};

  // Getters
  ActionPlanState get state => _state;
  ActionPlanResponse? get actionPlan => _actionPlan;
  ActionTask? get currentTask => _currentTask;
  List<ActionTask> get tasksByCategory => _tasksByCategory;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ActionPlanState.loading;
  bool get hasError => _state == ActionPlanState.error;
  bool get hasActionPlan => _actionPlan != null;

  // Computed getters
  int get totalTasks => _actionPlan?.tasks.length ?? 0;
  int get completedTasks => _actionPlan?.tasks.where((t) => t.isCompleted).length ?? 0;
  int get pendingTasks => totalTasks - completedTasks;
  double get completionPercentage => totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

  // Get Action Plan
  Future<bool> getActionPlan() async {
    _setState(ActionPlanState.loading);
    _errorMessage = null;

    try {
      final response = await _actionPlanRepository.getActionPlan();

      debugPrint('Action Plan Response - Success: ${response.success}');
      debugPrint('Action Plan Response - Data: ${response.data}');
      debugPrint('Action Plan Response - Error: ${response.error?.message}');

      if (response.success && response.data != null) {
        _actionPlan = response.data;
        debugPrint('Action Plan loaded with ${_actionPlan?.tasks.length ?? 0} tasks');
        _setState(ActionPlanState.success);
        return true;
      } else {
        _errorMessage =
            response.error?.message ?? response.message ?? 'Failed to fetch action plan';
        debugPrint('Action Plan Error: $_errorMessage');
        _setState(ActionPlanState.error);
        return false;
      }
    } catch (e, stackTrace) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to fetch action plan');
      debugPrint('Action Plan Exception: $e');
      debugPrint('Stack trace: $stackTrace');
      _setState(ActionPlanState.error);
      return false;
    }
  }

  // Get Task Details
  Future<bool> getTaskDetails(String taskId) async {
    _setState(ActionPlanState.loading);
    _errorMessage = null;

    try {
      final response = await _actionPlanRepository.getTaskDetails(taskId);

      if (response.success && response.data != null) {
        _currentTask = response.data!.task;
        _setState(ActionPlanState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch task';
        _setState(ActionPlanState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to fetch task');
      _setState(ActionPlanState.error);
      return false;
    }
  }

  // Update Task Status
  Future<bool> updateTaskStatus(String taskId, bool isCompleted) async {
    debugPrint(
      'ActionPlanProvider.updateTaskStatus called with taskId: $taskId, isCompleted: $isCompleted',
    );

    // Optimistic update
    final previousState = _taskCompletionStates[taskId];
    _taskCompletionStates[taskId] = isCompleted;

    // Update in action plan
    if (_actionPlan != null) {
      final taskIndex = _actionPlan!.tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        final updatedTask = _actionPlan!.tasks[taskIndex].copyWith(isCompleted: isCompleted);
        _actionPlan!.tasks[taskIndex] = updatedTask;
        notifyListeners();
      }
    }

    // Also update current task if it matches
    if (_currentTask?.id == taskId) {
      _currentTask = _currentTask!.copyWith(isCompleted: isCompleted);
      notifyListeners();
    }

    _errorMessage = null;

    try {
      final response = await _actionPlanRepository.updateTaskStatus(
        taskId: taskId,
        request: UpdateTaskStatusRequest(isCompleted: isCompleted),
      );

      if (response.success && response.data != null) {
        // Update task with server response
        if (_actionPlan != null) {
          final taskIndex = _actionPlan!.tasks.indexWhere((t) => t.id == taskId);
          if (taskIndex != -1) {
            final existingTask = _actionPlan!.tasks[taskIndex];
            _actionPlan!.tasks[taskIndex] = ActionTask(
              id: existingTask.id,
              assessmentId: existingTask.assessmentId,
              title: existingTask.title,
              description: existingTask.description,
              category: existingTask.category,
              priority: existingTask.priority,
              dueDate: existingTask.dueDate,
              isCompleted: response.data!.isCompleted,
              completedDate: response.data!.completedDate,
              sortOrder: existingTask.sortOrder,
            );
          }
        }

        if (_currentTask?.id == taskId) {
          final existingTask = _currentTask!;
          _currentTask = ActionTask(
            id: existingTask.id,
            assessmentId: existingTask.assessmentId,
            title: existingTask.title,
            description: existingTask.description,
            category: existingTask.category,
            priority: existingTask.priority,
            dueDate: existingTask.dueDate,
            isCompleted: response.data!.isCompleted,
            completedDate: response.data!.completedDate,
            sortOrder: existingTask.sortOrder,
          );
        }

        notifyListeners();
        return true;
      } else {
        // Revert optimistic update
        if (previousState != null) {
          _taskCompletionStates[taskId] = previousState;
        } else {
          _taskCompletionStates.remove(taskId);
        }

        _errorMessage = response.error?.message ?? 'Failed to update task';
        await getActionPlan(); // Refresh to get correct state
        return false;
      }
    } catch (e) {
      // Revert optimistic update
      if (previousState != null) {
        _taskCompletionStates[taskId] = previousState;
      } else {
        _taskCompletionStates.remove(taskId);
      }

      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to update task');
      await getActionPlan(); // Refresh to get correct state
      return false;
    }
  }

  // Update Task Notes
  Future<bool> updateTaskNotes(String taskId, String notes) async {
    _errorMessage = null;

    try {
      final response = await _actionPlanRepository.updateTaskNotes(
        taskId: taskId,
        request: UpdateTaskNotesRequest(notes: notes),
      );

      if (response.success && response.data != null) {
        // Notes updated successfully - no need to update task object
        // Notes are likely displayed separately in the UI
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to update notes';
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Failed to update notes');
      return false;
    }
  }

  // Get Tasks by Category - Removed from API
  // Note: Filter tasks by category locally instead
  // Use getTasksByPriority() or filter _actionPlan.tasks manually

  // Get tasks by priority
  List<ActionTask> getTasksByPriority(String priority) {
    if (_actionPlan == null) return [];
    return _actionPlan!.tasks.where((t) => t.priority == priority).toList();
  }

  // Get pending tasks
  List<ActionTask> getPendingTasks() {
    if (_actionPlan == null) return [];
    return _actionPlan!.tasks.where((t) => !t.isCompleted).toList();
  }

  // Get completed tasks
  List<ActionTask> getCompletedTasks() {
    if (_actionPlan == null) return [];
    return _actionPlan!.tasks.where((t) => t.isCompleted).toList();
  }

  // Refresh action plan (silent)
  Future<void> refreshActionPlan() async {
    try {
      final response = await _actionPlanRepository.getActionPlan();
      if (response.success && response.data != null) {
        _actionPlan = response.data;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _actionPlan = null;
    _currentTask = null;
    _tasksByCategory = [];
    _taskCompletionStates = {};
    _errorMessage = null;
    _setState(ActionPlanState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == ActionPlanState.error) {
      _setState(ActionPlanState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(ActionPlanState newState) {
    _state = newState;
    notifyListeners();
  }
}
