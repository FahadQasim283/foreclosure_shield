class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role; // 'client' or 'admin'
  final DateTime createdAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? subscriptionPlan; // 'basic', 'pro', 'premium'
  final DateTime? subscriptionExpiryDate;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.createdAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.subscriptionPlan,
    this.subscriptionExpiryDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? false,
      subscriptionPlan: json['subscription_plan'] as String?,
      subscriptionExpiryDate: json['subscription_expiry_date'] != null
          ? DateTime.parse(json['subscription_expiry_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'subscription_plan': subscriptionPlan,
      'subscription_expiry_date': subscriptionExpiryDate?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
    DateTime? createdAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? subscriptionPlan,
    DateTime? subscriptionExpiryDate,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
    );
  }
}
