import 'package:flutter/material.dart';
import 'package:foreclosure_shield/core/constants/string_consts.dart';
import 'package:foreclosure_shield/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'core/routes/route_generator.dart';
import 'state/auth_provider.dart';
import 'state/user_provider.dart';
import 'state/assessment_provider.dart';
import 'state/action_plan_provider.dart';
import 'state/dashboard_provider.dart';
import 'state/document_provider.dart';
import 'state/notification_provider.dart';
import 'state/settings_provider.dart';
import 'state/subscription_provider.dart';
import 'state/support_provider.dart';

class AIForeClosureShield extends StatefulWidget {
  const AIForeClosureShield({super.key});

  @override
  State<AIForeClosureShield> createState() => _AIForeClosureShieldState();
}

class _AIForeClosureShieldState extends State<AIForeClosureShield> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(create: (_) => ActionPlanProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        routerConfig: RouteGenerator.router,
      ),
    );
  }
}
