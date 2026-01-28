// ===============================
// SUBSCRIPTION PLAN MODEL
// ===============================
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final int maxAssessments;
  final int maxDocuments;
  final bool hasEmailSupport;
  final bool hasPhoneSupport;
  final bool hasPrioritySupport;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    required this.maxAssessments,
    required this.maxDocuments,
    required this.hasEmailSupport,
    required this.hasPhoneSupport,
    required this.hasPrioritySupport,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num).toDouble(),
      features: (json['features'] as List).map((e) => e as String).toList(),
      maxAssessments: json['maxAssessments'] as int,
      maxDocuments: json['maxDocuments'] as int,
      hasEmailSupport: json['hasEmailSupport'] as bool,
      hasPhoneSupport: json['hasPhoneSupport'] as bool,
      hasPrioritySupport: json['hasPrioritySupport'] as bool,
    );
  }
}

// ===============================
// USER SUBSCRIPTION MODEL
// ===============================
class UserSubscription {
  final String id;
  final String planId;
  final String planName;
  final String status;
  final DateTime startDate;
  final DateTime expiryDate;
  final String billingCycle;
  final double amount;
  final bool autoRenew;

  UserSubscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.status,
    required this.startDate,
    required this.expiryDate,
    required this.billingCycle,
    required this.amount,
    required this.autoRenew,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String,
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      billingCycle: json['billingCycle'] as String,
      amount: (json['amount'] as num).toDouble(),
      autoRenew: json['autoRenew'] as bool,
    );
  }

  UserSubscription copyWith({
    String? id,
    String? planId,
    String? planName,
    String? status,
    DateTime? startDate,
    DateTime? expiryDate,
    String? billingCycle,
    double? amount,
    bool? autoRenew,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      billingCycle: billingCycle ?? this.billingCycle,
      amount: amount ?? this.amount,
      autoRenew: autoRenew ?? this.autoRenew,
    );
  }
}

// ===============================
// REQUEST MODELS
// ===============================

class SubscribeRequest {
  final String planId;
  final String paymentMethodId;
  final String billingCycle;

  SubscribeRequest({
    required this.planId,
    required this.paymentMethodId,
    required this.billingCycle,
  });

  Map<String, dynamic> toJson() {
    return {'planId': planId, 'paymentMethodId': paymentMethodId, 'billingCycle': billingCycle};
  }
}

class CancelSubscriptionRequest {
  final String? reason;

  CancelSubscriptionRequest({this.reason});

  Map<String, dynamic> toJson() {
    return {if (reason != null) 'reason': reason};
  }
}

// ===============================
// RESPONSE MODELS
// ===============================

class SubscriptionPlansResponse {
  final List<SubscriptionPlan> plans;

  SubscriptionPlansResponse({required this.plans});

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansResponse(
      plans: (json['plans'] as List)
          .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CurrentSubscriptionResponse {
  final UserSubscription subscription;

  CurrentSubscriptionResponse({required this.subscription});

  factory CurrentSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CurrentSubscriptionResponse(subscription: UserSubscription.fromJson(json));
  }
}

class SubscribeResponse {
  final UserSubscription subscription;
  final String paymentStatus;

  SubscribeResponse({required this.subscription, required this.paymentStatus});

  factory SubscribeResponse.fromJson(Map<String, dynamic> json) {
    return SubscribeResponse(
      subscription: UserSubscription.fromJson(json['subscription']),
      paymentStatus: json['paymentStatus'] as String,
    );
  }
}

class CancelSubscriptionResponse {
  final String status;
  final DateTime cancelledAt;
  final DateTime validUntil;

  CancelSubscriptionResponse({
    required this.status,
    required this.cancelledAt,
    required this.validUntil,
  });

  factory CancelSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CancelSubscriptionResponse(
      status: json['status'] as String,
      cancelledAt: DateTime.parse(json['cancelledAt'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
    );
  }
}
