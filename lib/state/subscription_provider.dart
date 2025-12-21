import 'package:flutter/foundation.dart';
import '../data/models/subscription_models.dart';
import '../repo/subscription_repository.dart';

enum SubscriptionState { idle, loading, success, error }

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();

  SubscriptionState _state = SubscriptionState.idle;
  List<SubscriptionPlan> _plans = [];
  UserSubscription? _currentSubscription;
  String? _errorMessage;

  // Getters
  SubscriptionState get state => _state;
  List<SubscriptionPlan> get plans => _plans;
  UserSubscription? get currentSubscription => _currentSubscription;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == SubscriptionState.loading;
  bool get hasError => _state == SubscriptionState.error;
  bool get hasActivePlan => _currentSubscription?.status == 'ACTIVE';
  bool get isFreePlan => _currentSubscription == null || _currentSubscription!.planId == 'free';

  // Computed getters
  int? get daysUntilExpiry {
    if (_currentSubscription?.expiryDate == null) return null;
    final expiryDate = _currentSubscription!.expiryDate;
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  bool get isExpiringSoon {
    final days = daysUntilExpiry;
    return days != null && days <= 7 && days > 0;
  }

  bool get isExpired {
    final days = daysUntilExpiry;
    return days != null && days < 0;
  }

  // Get Subscription Plans
  Future<bool> getSubscriptionPlans() async {
    _setState(SubscriptionState.loading);
    _errorMessage = null;

    try {
      final response = await _subscriptionRepository.getSubscriptionPlans();

      if (response.success && response.data != null) {
        _plans = response.data!.plans;
        _setState(SubscriptionState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch plans';
        _setState(SubscriptionState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SubscriptionState.error);
      return false;
    }
  }

  // Get Current Subscription
  Future<bool> getCurrentSubscription() async {
    _setState(SubscriptionState.loading);
    _errorMessage = null;

    try {
      final response = await _subscriptionRepository.getCurrentSubscription();

      if (response.success && response.data != null) {
        _currentSubscription = response.data!.subscription;
        _setState(SubscriptionState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch subscription';
        _setState(SubscriptionState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SubscriptionState.error);
      return false;
    }
  }

  // Subscribe
  Future<bool> subscribe(SubscribeRequest request) async {
    _setState(SubscriptionState.loading);
    _errorMessage = null;

    try {
      final response = await _subscriptionRepository.subscribe(request);

      if (response.success && response.data != null) {
        _currentSubscription = response.data!.subscription;

        // Check payment status
        if (response.data!.paymentStatus != 'SUCCESS') {
          _errorMessage = 'Payment failed. Please try again.';
          _setState(SubscriptionState.error);
          return false;
        }

        _setState(SubscriptionState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Subscription failed';
        _setState(SubscriptionState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SubscriptionState.error);
      return false;
    }
  }

  // Cancel Subscription
  Future<bool> cancelSubscription({String? reason}) async {
    _setState(SubscriptionState.loading);
    _errorMessage = null;

    try {
      final response = await _subscriptionRepository.cancelSubscription(
        CancelSubscriptionRequest(reason: reason),
      );

      if (response.success && response.data != null) {
        // Update status to CANCELLED
        if (_currentSubscription != null) {
          _currentSubscription = _currentSubscription!.copyWith(status: response.data!.status);
        }
        _setState(SubscriptionState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to cancel subscription';
        _setState(SubscriptionState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SubscriptionState.error);
      return false;
    }
  }

  // Get plan by ID
  SubscriptionPlan? getPlanById(String planId) {
    try {
      return _plans.firstWhere((p) => p.id == planId);
    } catch (e) {
      return null;
    }
  }

  // Get current plan details
  SubscriptionPlan? getCurrentPlan() {
    if (_currentSubscription == null) return null;
    return getPlanById(_currentSubscription!.planId);
  }

  // Check if feature is available
  bool hasFeature(String feature) {
    final plan = getCurrentPlan();
    if (plan == null) return false;
    return plan.features.contains(feature);
  }

  // Refresh subscription (silent)
  Future<void> refreshSubscription() async {
    try {
      final response = await _subscriptionRepository.getCurrentSubscription();
      if (response.success && response.data != null) {
        _currentSubscription = response.data!.subscription;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _plans = [];
    _currentSubscription = null;
    _errorMessage = null;
    _setState(SubscriptionState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == SubscriptionState.error) {
      _setState(SubscriptionState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(SubscriptionState newState) {
    _state = newState;
    notifyListeners();
  }
}
