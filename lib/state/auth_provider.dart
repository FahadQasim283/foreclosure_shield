import 'package:flutter/foundation.dart';
import '../data/models/auth_models.dart';
import '../data/models/user.dart';
import '../repo/auth_repository.dart';
import '../services/local_storage/token_storage.dart';
import '../core/utils/error_handler.dart';

enum AuthState { idle, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  AuthState _state = AuthState.idle;
  User? _currentUser;
  String? _errorMessage;
  String? _accessToken;
  String? _refreshToken;

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isAuthenticated => _state == AuthState.authenticated && _currentUser != null;
  bool get isLoading => _state == AuthState.loading;

  // Initialize - Check if user is already logged in
  Future<void> initialize() async {
    _setState(AuthState.loading);

    try {
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        _accessToken = token;
        _refreshToken = await TokenStorage.getRefreshToken();

        // Fetch user profile to complete authentication
        try {
          final response = await _authRepository.getCurrentUser();
          if (response.success && response.data != null) {
            _currentUser = response.data;
            _setState(AuthState.authenticated);
          } else {
            // Token exists but unable to fetch user, clear tokens
            await TokenStorage.clearAll();
            _accessToken = null;
            _refreshToken = null;
            _setState(AuthState.unauthenticated);
          }
        } catch (e) {
          // Error fetching user, clear tokens
          await TokenStorage.clearAll();
          _accessToken = null;
          _refreshToken = null;
          _setState(AuthState.unauthenticated);
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setState(AuthState.unauthenticated);
    }
  }

  // Signup
  Future<bool> signup(SignupRequest request) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      final response = await _authRepository.signup(request);

      if (response.success && response.data != null) {
        _currentUser = response.data!.user;
        _accessToken = response.data!.token;
        _refreshToken = response.data!.refreshToken;

        // Tokens are already saved in repository
        _setState(AuthState.authenticated);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Signup failed';
        _setState(AuthState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(AuthState.error);
      return false;
    }
  }

  // Login
  Future<bool> login(LoginRequest request) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      final response = await _authRepository.login(request);

      if (response.success && response.data != null) {
        _currentUser = response.data!.user;
        _accessToken = response.data!.token;
        _refreshToken = response.data!.refreshToken;

        _setState(AuthState.authenticated);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Login failed';
        _setState(AuthState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Login failed');
      _setState(AuthState.error);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _setState(AuthState.loading);

    try {
      await _authRepository.logout();
    } catch (e) {
      // Ignore logout errors, clear local data anyway
    }

    // Clear all local data
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    _errorMessage = null;

    _setState(AuthState.unauthenticated);
  }

  // Forgot Password
  Future<bool> forgotPassword(ForgotPasswordRequest request) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      final response = await _authRepository.forgotPassword(request);

      if (response.success) {
        _setState(AuthState.idle);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Request failed';
        _setState(AuthState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Request failed');
      _setState(AuthState.error);
      return false;
    }
  }

  // Verify OTP
  Future<String?> verifyOtp(VerifyOtpRequest request) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      final response = await _authRepository.verifyOtp(request);

      if (response.success && response.data != null) {
        _setState(AuthState.idle);
        return response.data!.resetToken;
      } else {
        _errorMessage = response.error?.message ?? 'OTP verification failed';
        _setState(AuthState.error);
        return null;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'OTP verification failed');
      _setState(AuthState.error);
      return null;
    }
  }

  // Reset Password
  Future<bool> resetPassword(ResetPasswordRequest request) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      final response = await _authRepository.resetPassword(request);

      if (response.success) {
        _setState(AuthState.idle);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Password reset failed';
        _setState(AuthState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e, 'Password reset failed');
      _setState(AuthState.error);
      return false;
    }
  }

  // Update current user (called after profile update)
  void updateCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(AuthState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
