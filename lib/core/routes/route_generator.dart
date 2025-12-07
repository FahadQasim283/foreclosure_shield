import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/routes/route_names.dart';
import '/presentation/screens/splash_screen.dart';
import '/presentation/screens/auth/login_screen.dart';
import '/presentation/screens/auth/signup_screen.dart';
import '/presentation/screens/main/main_screen.dart';
import '/presentation/screens/assessment/start_assessment_screen.dart';
import '/presentation/screens/assessment/assessment_result_screen.dart';
import '/presentation/screens/action_plan/action_plan_screen.dart';
import '/presentation/screens/documents/generate_letter_screen.dart';
import '/presentation/screens/notifications/notifications_screen.dart';
import '/presentation/screens/settings/settings_screen.dart';
import '/presentation/screens/subscription/subscription_plan_screen.dart';
import '/presentation/screens/help_support/help_support_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: kDebugMode,
    navigatorKey: rootNavigatorKey,
    routes: [
      // Splash
      GoRoute(path: RouteNames.splash, builder: (context, state) => const SplashScreen()),

      // Authentication
      GoRoute(path: RouteNames.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: RouteNames.signup, builder: (context, state) => const SignupScreen()),

      // Main App
      GoRoute(path: RouteNames.main, builder: (context, state) => const MainScreen()),

      // Risk Assessment
      GoRoute(
        path: RouteNames.startAssessment,
        builder: (context, state) => const StartAssessmentScreen(),
      ),
      GoRoute(
        path: RouteNames.assessmentResult,
        builder: (context, state) => const AssessmentResultScreen(),
      ),

      // Action Plan
      GoRoute(path: RouteNames.actionPlan, builder: (context, state) => const ActionPlanScreen()),

      // Documents
      GoRoute(
        path: RouteNames.generateLetter,
        builder: (context, state) => const GenerateLetterScreen(),
      ),

      // Notifications
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Settings & Profile
      GoRoute(path: RouteNames.settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(
        path: RouteNames.subscriptionPlans,
        builder: (context, state) => const SubscriptionPlanScreen(),
      ),
      GoRoute(path: RouteNames.helpSupport, builder: (context, state) => const HelpSupportScreen()),

      // Add more routes here as screens are created
    ],
    errorBuilder: (context, state) =>
        ErrorScreen(errorMessage: state.error?.toString(), currentLocation: state.matchedLocation),
  );
}

class ErrorScreen extends StatelessWidget {
  final String? errorMessage;
  final String? currentLocation;

  const ErrorScreen({super.key, this.errorMessage, this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go(RouteNames.splash),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (errorMessage != null) ...[
                Text(
                  errorMessage!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
              if (currentLocation != null && kDebugMode) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Location: $currentLocation',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(RouteNames.splash),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
