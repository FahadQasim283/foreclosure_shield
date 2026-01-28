import '/data/models/user.dart';

// Type alias for backward compatibility
typedef UpdateUserProfileRequest = UpdateProfileRequest;

// ===============================
// USER REQUEST MODELS
// ===============================

class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? propertyAddress;
  final String? city;
  final String? state;
  final String? zipCode;

  UpdateProfileRequest({
    this.name,
    this.phone,
    this.propertyAddress,
    this.city,
    this.state,
    this.zipCode,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (propertyAddress != null) data['propertyAddress'] = propertyAddress;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (zipCode != null) data['zipCode'] = zipCode;
    return data;
  }
}

// ===============================
// USER RESPONSE MODELS
// ===============================

class UserProfileResponse {
  final User user;

  UserProfileResponse({required this.user});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(user: User.fromJson(json));
  }
}

class UpdateProfileResponse {
  final User user;

  UpdateProfileResponse({required this.user});

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(user: User.fromJson(json));
  }
}

class UploadProfileImageResponse {
  final String profileImage;

  UploadProfileImageResponse({required this.profileImage});

  factory UploadProfileImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadProfileImageResponse(profileImage: json['profileImage'] as String);
  }
}
