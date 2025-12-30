import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/state/subscription_provider.dart';
import '/data/models/subscription_models.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  bool _isAnnual = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    await Future.wait([
      subscriptionProvider.getSubscriptionPlans(),
      subscriptionProvider.getCurrentSubscription(),
    ]);
  }

  Future<void> _subscribe(String planId) async {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    final success = await subscriptionProvider.subscribe(
      SubscribeRequest(
        planId: planId,
        billingCycle: _isAnnual ? 'annual' : 'monthly',
        paymentMethodId: 'default_payment_method', // TODO: Get from payment method selection
      ),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Subscription updated successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(subscriptionProvider.errorMessage ?? 'Failed to update subscription'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (subscriptionProvider.isLoading && subscriptionProvider.plans.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Subscription Plans')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final currentSubscription = subscriptionProvider.currentSubscription;
        final plans = subscriptionProvider.plans;

        return Scaffold(
          appBar: AppBar(title: const Text('Subscription Plans')),
          body: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Current Plan Badge
                if (currentSubscription != null && currentSubscription.status == 'ACTIVE')
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.secondary),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.workspace_premium, color: AppColors.secondary, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Plan: ${currentSubscription.planName}',
                                style: AppTypography.h3.copyWith(color: AppColors.secondary),
                              ),
                              Text(
                                'Active until ${_formatDate(currentSubscription.expiryDate)}',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Billing Toggle
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildToggleButton('Monthly', !_isAnnual),
                        _buildToggleButton('Annual (Save 20%)', _isAnnual),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Plans from API
                ...plans.map(
                  (plan) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPlanCard(
                      plan: plan,
                      isCurrent: currentSubscription?.planId == plan.id,
                      onSubscribe: () => _subscribe(plan.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _isAnnual = text.contains('Annual'));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required SubscriptionPlan plan,
    required bool isCurrent,
    required VoidCallback onSubscribe,
  }) {
    final color = _getPlanColor(plan.name);
    final price = _isAnnual
        ? plan.yearlyPrice.toStringAsFixed(0)
        : plan.monthlyPrice.toStringAsFixed(0);

    return Card(
      elevation: isCurrent ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isCurrent ? AppColors.secondary : Colors.transparent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name.toUpperCase(), style: AppTypography.h2.copyWith(color: color)),
                      const SizedBox(height: 4),
                      Text(
                        plan.description,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600),
                      ),
                    ],
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('ACTIVE', style: AppTypography.badge.copyWith(color: Colors.white)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$', style: AppTypography.h3.copyWith(color: color)),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _isAnnual ? 'per month\n(billed annually)' : 'per month',
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...plan.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(feature, style: AppTypography.bodyMedium)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCurrent ? null : onSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isCurrent ? 'Current Plan' : 'Subscribe',
                  style: AppTypography.buttonLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPlanColor(String planName) {
    switch (planName.toLowerCase()) {
      case 'free':
        return Colors.grey;
      case 'basic':
        return AppColors.blue;
      case 'premium':
        return AppColors.secondary;
      case 'enterprise':
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
