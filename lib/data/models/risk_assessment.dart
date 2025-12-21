class RiskAssessment {
  final String id;
  final String userId;
  final int riskScore; // 0-100
  final String riskCategory; // 'LOW', 'AT-RISK', 'URGENT', 'CRITICAL'
  final DateTime assessmentDate;
  final DateTime? auctionDate;
  final int? daysToAuction;

  // Foreclosure Details
  final double? amountOwed;
  final double? propertyValue;
  final int? missedPayments;
  final String? lenderName;
  final String? lenderPhone;
  final String? propertyAddress;
  final String? propertyCity;
  final String? propertyState;
  final String? propertyZip;

  // Financial Details
  final double? monthlyIncome;
  final double? monthlyExpenses;
  final bool? hasOtherDebts;
  final double? otherDebtsAmount;

  // Legal Status
  final String? legalStatus; // 'pre_foreclosure', 'foreclosure_filed', 'auction_scheduled'
  final bool? hasLegalRepresentation;
  final bool? hasReceivedNotices;

  // Additional Info
  final String? occupancyStatus; // 'owner_occupied', 'rental', 'vacant'
  final bool? wantsToKeepHome;
  final String? notes;

  // AI Generated
  final String? riskSummary;
  final String? actionPlan30Day;
  final String? actionPlan60Day;

  RiskAssessment({
    required this.id,
    required this.userId,
    required this.riskScore,
    required this.riskCategory,
    required this.assessmentDate,
    this.auctionDate,
    this.daysToAuction,
    this.amountOwed,
    this.propertyValue,
    this.missedPayments,
    this.lenderName,
    this.lenderPhone,
    this.propertyAddress,
    this.propertyCity,
    this.propertyState,
    this.propertyZip,
    this.monthlyIncome,
    this.monthlyExpenses,
    this.hasOtherDebts,
    this.otherDebtsAmount,
    this.legalStatus,
    this.hasLegalRepresentation,
    this.hasReceivedNotices,
    this.occupancyStatus,
    this.wantsToKeepHome,
    this.notes,
    this.riskSummary,
    this.actionPlan30Day,
    this.actionPlan60Day,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    // Handle both backend response format (camelCase) and legacy format (snake_case)
    return RiskAssessment(
      id: (json['id'] ?? json['id']).toString(),
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      riskScore: (json['riskScore'] ?? json['risk_score'] ?? 0) as int,
      riskCategory:
          (json['riskCategory'] ?? json['riskLevel'] ?? json['risk_category'] ?? 'SECURE')
              as String,
      assessmentDate: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : (json['assessment_date'] != null
                ? DateTime.parse(json['assessment_date'] as String)
                : DateTime.now()),
      auctionDate: json['auction_date'] != null
          ? DateTime.parse(json['auction_date'] as String)
          : null,
      daysToAuction: json['days_to_auction'] as int?,
      // Extract from financialData if present, otherwise use direct fields
      amountOwed: json['financialData'] != null
          ? (json['financialData']['amountOwed'] as num?)?.toDouble()
          : (json['amount_owed'] as num?)?.toDouble(),
      propertyValue: json['financialData'] != null
          ? (json['financialData']['propertyValue'] as num?)?.toDouble()
          : (json['property_value'] as num?)?.toDouble(),
      missedPayments: json['financialData'] != null
          ? json['financialData']['missedPayments'] as int?
          : json['missed_payments'] as int?,
      monthlyIncome: json['financialData'] != null
          ? (json['financialData']['monthlyIncome'] as num?)?.toDouble()
          : (json['monthly_income'] as num?)?.toDouble(),
      monthlyExpenses: json['financialData'] != null
          ? (json['financialData']['monthlyExpenses'] as num?)?.toDouble()
          : (json['monthly_expenses'] as num?)?.toDouble(),
      lenderName: json['lender_name'] as String?,
      lenderPhone: json['lender_phone'] as String?,
      propertyAddress: json['property_address'] as String?,
      propertyCity: json['property_city'] as String?,
      propertyState: json['property_state'] as String?,
      propertyZip: json['property_zip'] as String?,
      hasOtherDebts: json['has_other_debts'] as bool?,
      otherDebtsAmount: (json['other_debts_amount'] as num?)?.toDouble(),
      legalStatus: json['legal_status'] as String?,
      hasLegalRepresentation: json['has_legal_representation'] as bool?,
      hasReceivedNotices: json['has_received_notices'] as bool?,
      occupancyStatus: json['occupancy_status'] as String?,
      wantsToKeepHome: json['wants_to_keep_home'] as bool?,
      notes: json['notes'] as String?,
      riskSummary: json['risk_summary'] as String?,
      actionPlan30Day: json['action_plan_30_day'] as String?,
      actionPlan60Day: json['action_plan_60_day'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'risk_score': riskScore,
      'risk_category': riskCategory,
      'assessment_date': assessmentDate.toIso8601String(),
      'auction_date': auctionDate?.toIso8601String(),
      'days_to_auction': daysToAuction,
      'amount_owed': amountOwed,
      'property_value': propertyValue,
      'missed_payments': missedPayments,
      'lender_name': lenderName,
      'lender_phone': lenderPhone,
      'property_address': propertyAddress,
      'property_city': propertyCity,
      'property_state': propertyState,
      'property_zip': propertyZip,
      'monthly_income': monthlyIncome,
      'monthly_expenses': monthlyExpenses,
      'has_other_debts': hasOtherDebts,
      'other_debts_amount': otherDebtsAmount,
      'legal_status': legalStatus,
      'has_legal_representation': hasLegalRepresentation,
      'has_received_notices': hasReceivedNotices,
      'occupancy_status': occupancyStatus,
      'wants_to_keep_home': wantsToKeepHome,
      'notes': notes,
      'risk_summary': riskSummary,
      'action_plan_30_day': actionPlan30Day,
      'action_plan_60_day': actionPlan60Day,
    };
  }

  double get ltvRatio {
    if (amountOwed != null && propertyValue != null && propertyValue! > 0) {
      return (amountOwed! / propertyValue!) * 100;
    }
    return 0.0;
  }

  double get monthlyDeficit {
    if (monthlyIncome != null && monthlyExpenses != null) {
      return monthlyExpenses! - monthlyIncome!;
    }
    return 0.0;
  }
}
