import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/routes/route_names.dart';
import '/presentation/screens/splash_screen.dart';
import '/presentation/screens/auth/login_screen.dart';
import '/presentation/screens/auth/signup_screen.dart';
import '/presentation/screens/auth/forgot_password_screen.dart';
import '/presentation/screens/auth/verify_otp_screen.dart';
import '/presentation/screens/main/main_screen.dart';
import '/presentation/screens/assessment/start_assessment_screen.dart';
import '/presentation/screens/assessment/assessment_result_screen.dart';
import '/presentation/screens/assessment/assessment_questionnaire_screen.dart';
import '/presentation/screens/assessment/assessment_history_screen.dart';
import '/presentation/screens/action_plan/action_plan_screen.dart';
import '/presentation/screens/action_plan/task_details_screen.dart';
import '/presentation/screens/documents/generate_letter_screen.dart';
import '/presentation/screens/documents/document_details_screen.dart';
import '/presentation/screens/documents/upload_document_screen.dart';
import '/presentation/screens/notifications/notifications_screen.dart';
import '/presentation/screens/settings/settings_screen.dart';
import '/presentation/screens/profile/edit_profile_screen.dart';
import '/presentation/screens/about/about_screen.dart';
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
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.verifyOtp,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return VerifyOtpScreen(email: email);
        },
      ),

      // Main App
      GoRoute(path: RouteNames.main, builder: (context, state) => const MainScreen()),

      // Risk Assessment
      GoRoute(
        path: RouteNames.startAssessment,
        builder: (context, state) => const StartAssessmentScreen(),
      ),
      GoRoute(
        path: RouteNames.assessmentQuestionnaire,
        builder: (context, state) => const AssessmentQuestionnaireScreen(),
      ),
      GoRoute(
        path: RouteNames.assessmentResult,
        builder: (context, state) => const AssessmentResultScreen(),
      ),
      GoRoute(
        path: RouteNames.assessmentHistory,
        builder: (context, state) => const AssessmentHistoryScreen(),
      ),

      // Action Plan
      GoRoute(path: RouteNames.actionPlan, builder: (context, state) => const ActionPlanScreen()),
      GoRoute(
        path: '${RouteNames.taskDetails}/:id',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailsScreen(taskId: taskId);
        },
      ),

      // Documents
      GoRoute(
        path: RouteNames.generateLetter,
        builder: (context, state) => const GenerateLetterScreen(),
      ),
      GoRoute(
        path: '${RouteNames.documentDetails}/:id',
        builder: (context, state) {
          final documentId = state.pathParameters['id']!;
          return DocumentDetailsScreen(documentId: documentId);
        },
      ),
      GoRoute(
        path: RouteNames.uploadDocument,
        builder: (context, state) => const UploadDocumentScreen(),
      ),

      // Notifications
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Settings & Profile
      GoRoute(path: RouteNames.settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: RouteNames.editProfile, builder: (context, state) => const EditProfileScreen()),
      GoRoute(
        path: RouteNames.subscription,
        builder: (context, state) => const SubscriptionPlanScreen(),
      ),
      GoRoute(
        path: RouteNames.subscriptionPlans,
        builder: (context, state) => const SubscriptionPlanScreen(),
      ),
      GoRoute(path: RouteNames.helpSupport, builder: (context, state) => const HelpSupportScreen()),
      GoRoute(path: RouteNames.about, builder: (context, state) => const AboutScreen()),

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
