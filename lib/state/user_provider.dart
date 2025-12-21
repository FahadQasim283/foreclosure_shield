import 'package:flutter/foundation.dart';
import '../data/models/api_response.dart';
import '../data/models/user_models.dart';
import '../data/models/user.dart';
import '../repo/user_repository.dart';

enum UserState { idle, loading, success, error }

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserState _state = UserState.idle;
  User? _user;
  String? _errorMessage;
  double _uploadProgress = 0.0;

  // Getters
  UserState get state => _state;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  bool get isLoading => _state == UserState.loading;
  bool get hasError => _state == UserState.error;

  // Get User Profile
  Future<bool> getUserProfile() async {
    _setState(UserState.loading);
    _errorMessage = null;

    try {
      final response = await _userRepository.getUserProfile();

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _setState(UserState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch profile';
        _setState(UserState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserState.error);
      return false;
    }
  }

  // Update User Profile
  Future<bool> updateUserProfile(UpdateUserProfileRequest request) async {
    _setState(UserState.loading);
    _errorMessage = null;

    try {
      final response = await _userRepository.updateUserProfile(request);

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _setState(UserState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to update profile';
        _setState(UserState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UserState.error);
      return false;
    }
  }

  // Upload Profile Image
  Future<bool> uploadProfileImage(String imagePath) async {
    _setState(UserState.loading);
    _errorMessage = null;
    _uploadProgress = 0.0;

    try {
      final response = await _userRepository.uploadProfileImage(
        imagePath,
        onProgress: (progress) {
          _uploadProgress = progress;
          notifyListeners();
        },
      );

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _uploadProgress = 1.0;
        _setState(UserState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to upload image';
        _uploadProgress = 0.0;
        _setState(UserState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _uploadProgress = 0.0;
      _setState(UserState.error);
      return false;
    }
  }

  // Refresh user data (silent refresh without loading state)
  Future<void> refreshUser() async {
    try {
      final response = await _userRepository.getUserProfile();
      if (response.success && response.data != null) {
        _user = response.data!.user;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _user = null;
    _errorMessage = null;
    _uploadProgress = 0.0;
    _setState(UserState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == UserState.error) {
      _setState(UserState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(UserState newState) {
    _state = newState;
    notifyListeners();
  }
}
