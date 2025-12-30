import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/core/routes/route_names.dart';
import '/state/assessment_provider.dart';
import '/data/models/assessment_models.dart';

class AssessmentQuestionnaireScreen extends StatefulWidget {
  const AssessmentQuestionnaireScreen({super.key});

  @override
  State<AssessmentQuestionnaireScreen> createState() => _AssessmentQuestionnaireScreenState();
}

class _AssessmentQuestionnaireScreenState extends State<AssessmentQuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyIncomeController = TextEditingController();
  final _monthlyExpensesController = TextEditingController();
  final _amountOwedController = TextEditingController();
  final _propertyValueController = TextEditingController();
  final _missedPaymentsController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  @override
  void dispose() {
    _monthlyIncomeController.dispose();
    _monthlyExpensesController.dispose();
    _amountOwedController.dispose();
    _propertyValueController.dispose();
    _missedPaymentsController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _submitAssessment() async {
    if (!_formKey.currentState!.validate()) return;

    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);

    final request = CreateAssessmentRequest(
      monthlyIncome: double.parse(_monthlyIncomeController.text),
      monthlyExpenses: double.parse(_monthlyExpensesController.text),
      amountOwed: double.parse(_amountOwedController.text),
      propertyValue: double.parse(_propertyValueController.text),
      missedPayments: int.parse(_missedPaymentsController.text),
      additionalInfo: _additionalInfoController.text.isNotEmpty
          ? _additionalInfoController.text
          : null,
    );

    final assessment = await assessmentProvider.createAssessment(request);

    if (mounted) {
      if (assessment != null) {
        context.push(RouteNames.assessmentResult);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(assessmentProvider.errorMessage ?? 'Failed to create assessment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, assessmentProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Risk Assessment Questionnaire')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.blue),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Answer these questions to assess your foreclosure risk',
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Financial Information', style: AppTypography.h2),
                  const SizedBox(height: 16),
                  _buildQuestionCard(
                    'Monthly Income',
                    'Enter your total monthly household income',
                    Icons.attach_money,
                    _monthlyIncomeController,
                  ),
                  _buildQuestionCard(
                    'Monthly Expenses',
                    'Enter your total monthly expenses',
                    Icons.receipt_long,
                    _monthlyExpensesController,
                  ),
                  _buildQuestionCard(
                    'Amount Owed',
                    'Total amount owed on your mortgage',
                    Icons.account_balance,
                    _amountOwedController,
                  ),
                  const SizedBox(height: 24),
                  Text('Property Information', style: AppTypography.h2),
                  const SizedBox(height: 16),
                  _buildQuestionCard(
                    'Property Value',
                    'Estimated current value of your property',
                    Icons.home,
                    _propertyValueController,
                  ),
                  _buildQuestionCard(
                    'Missed Payments',
                    'Number of missed mortgage payments',
                    Icons.calendar_month,
                    _missedPaymentsController,
                    isInteger: true,
                  ),
                  const SizedBox(height: 24),
                  Text('Additional Information (Optional)', style: AppTypography.h2),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _additionalInfoController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Provide any additional details about your situation...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: assessmentProvider.isLoading ? null : _submitAssessment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: assessmentProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Calculate Risk Score'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard(
    String title,
    String description,
    IconData icon,
    TextEditingController controller, {
    bool isInteger = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: AppTypography.bodySmall),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter value',
                prefixText: isInteger ? '' : '\$ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                if (isInteger) {
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                } else {
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
