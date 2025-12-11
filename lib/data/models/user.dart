class User {
  final String id;
  final String email;
  final String name;
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
    required this.id,
    required this.email,
    required this.name,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      propertyAddress: json['propertyAddress'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      subscriptionType: json['subscriptionType'] as String? ?? 'FREE',
      subscriptionExpiryDate: json['subscriptionExpiryDate'] != null
          ? DateTime.parse(json['subscriptionExpiryDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
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
    String? email,
    String? name,
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
      email: email ?? this.email,
      name: name ?? this.name,
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
