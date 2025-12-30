class User {
  final String? id;
  final String? username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profileImage;
  final String? propertyAddress;
  final String? city;
  final String? state;
  final String? zipCode;
  final String subscriptionType; // 'FREE', 'BASIC', 'PREMIUM'
  final DateTime? subscriptionExpiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id,
    this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.profileImage,
    this.propertyAddress,
    this.city,
    this.state,
    this.zipCode,
    this.subscriptionType = 'FREE',
    this.subscriptionExpiryDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Computed property for full name
  String get name => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  String get displayName => name.isNotEmpty ? name : username ?? email;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      username: json['username'] as String?,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? json['firstName'] as String?,
      lastName: json['last_name'] as String? ?? json['lastName'] as String?,
      phone: json['phone']?.toString(),
      profileImage: json['profile_image'] as String? ?? json['profileImage'] as String?,
      propertyAddress: json['propertyAddress'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      subscriptionType: json['subscriptionType'] as String? ?? 'FREE',
      subscriptionExpiryDate: json['subscriptionExpiryDate'] != null
          ? DateTime.parse(json['subscriptionExpiryDate'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'profile_image': profileImage,
      'propertyAddress': propertyAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'subscriptionType': subscriptionType,
      'subscriptionExpiryDate': subscriptionExpiryDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImage,
    String? propertyAddress,
    String? city,
    String? state,
    String? zipCode,
    String? subscriptionType,
    DateTime? subscriptionExpiryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
