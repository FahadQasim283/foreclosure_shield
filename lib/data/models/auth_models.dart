import '/data/models/user.dart';

// ===============================
// AUTH REQUEST MODELS
// ===============================

class SignupRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  SignupRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp};
  }
}

class ResetPasswordRequest {
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'resetToken': resetToken,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }
}

// ===============================
// AUTH RESPONSE MODELS
// ===============================

class AuthResponse {
  final User? user;
  final String token;
  final String refreshToken;

  AuthResponse({this.user, required this.token, required this.refreshToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

class ForgotPasswordResponse {
  final bool resetTokenSent;

  ForgotPasswordResponse({required this.resetTokenSent});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(resetTokenSent: json['resetTokenSent'] as bool);
  }
}

class VerifyOtpResponse {
  final bool verified;
  final String resetToken;

  VerifyOtpResponse({required this.verified, required this.resetToken});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      verified: json['verified'] as bool,
      resetToken: json['resetToken'] as String,
    );
  }
}

class ResetPasswordResponse {
  final bool passwordReset;

  ResetPasswordResponse({required this.passwordReset});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(passwordReset: json['passwordReset'] as bool? ?? true);
  }
}

class RefreshTokenResponse {
  final String token;
  final String refreshToken;

  RefreshTokenResponse({required this.token, required this.refreshToken});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
