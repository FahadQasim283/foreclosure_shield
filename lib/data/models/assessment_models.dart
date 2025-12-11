import '/data/models/risk_assessment.dart';
import '/data/models/api_response.dart';

// ===============================
// ASSESSMENT REQUEST MODELS
// ===============================

class CreateAssessmentRequest {
  final double monthlyIncome;
  final double monthlyExpenses;
  final double amountOwed;
  final double propertyValue;
  final int missedPayments;
  final String? additionalInfo;

  CreateAssessmentRequest({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.amountOwed,
    required this.propertyValue,
    required this.missedPayments,
    this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'amountOwed': amountOwed,
      'propertyValue': propertyValue,
      'missedPayments': missedPayments,
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
    };
  }
}

// ===============================
// ASSESSMENT RESPONSE MODELS
// ===============================

class AssessmentResponse {
  final RiskAssessment assessment;

  AssessmentResponse({required this.assessment});

  factory AssessmentResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentResponse(assessment: RiskAssessment.fromJson(json));
  }
}

class AssessmentHistoryResponse {
  final List<RiskAssessment> assessments;
  final Pagination pagination;

  AssessmentHistoryResponse({required this.assessments, required this.pagination});

  factory AssessmentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentHistoryResponse(
      assessments: (json['assessments'] as List)
          .map((e) => RiskAssessment.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class LatestAssessmentResponse {
  final RiskAssessment assessment;

  LatestAssessmentResponse({required this.assessment});

  factory LatestAssessmentResponse.fromJson(Map<String, dynamic> json) {
    return LatestAssessmentResponse(assessment: RiskAssessment.fromJson(json));
  }
}
