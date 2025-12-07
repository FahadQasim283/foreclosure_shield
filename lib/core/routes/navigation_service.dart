import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import 'route_config.dart';
import 'route_generator.dart';

class NavigationService {
  // Use the router's navigator key instead of a separate one
  static GlobalKey<NavigatorState> get navigatorKey => rootNavigatorKey;

  static BuildContext? get currentContext => navigatorKey.currentContext;

  // Starting flow navigation
  static void goToSplash() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.splash);
    }
  }

  static void goToGetStarted() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.getStarted);
    }
  }

  static void goToOnboarding() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.onboarding);
    }
  }

  // Authentication navigation
  static void goToLogin() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.login);
    }
  }

  static void goToSignup() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.signup);
    }
  }

  // Main app navigation
  static void goToMainTab() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.mainTab);
    }
  }

  static void goToHome() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.home);
    }
  }

  static void goToServices() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.services);
    }
  }

  static void goToBookings() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.bookings);
    }
  }

  static void goToProfile() {
    if (currentContext != null) {
      GoRouter.of(currentContext!).go(RouteNames.profile);
    }
  }

  static void push(String routePath) {
    if (currentContext != null && RouteConfig.isValidRoutePath(routePath)) {
      GoRouter.of(currentContext!).push(routePath);
    }
  }

  static void pushNamed(String routeName, {Map<String, String>? pathParameters}) {
    if (currentContext != null) {
      GoRouter.of(currentContext!).pushNamed(routeName, pathParameters: pathParameters ?? {});
    }
  }

  static void pop([dynamic result]) {
    if (currentContext != null) {
      GoRouter.of(currentContext!).pop(result);
    }
  }

  static bool canPop() {
    if (currentContext == null) return false;
    return GoRouter.of(currentContext!).canPop();
  }

  static void popUntil(String routePath) {
    if (currentContext == null) return;
    while (canPop() &&
        GoRouter.of(currentContext!).routerDelegate.currentConfiguration.fullPath != routePath) {
      pop();
    }
  }

  static void pushReplacement(String routePath) {
    if (currentContext != null && RouteConfig.isValidRoutePath(routePath)) {
      GoRouter.of(currentContext!).pushReplacement(routePath);
    }
  }

  static void goAndClearStack(String routePath) {
    if (currentContext != null && RouteConfig.isValidRoutePath(routePath)) {
      GoRouter.of(currentContext!).go(routePath);
    }
  }

  static Future<T?> showNavigationBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    if (currentContext == null) return Future.value(null);
    return showModalBottomSheet<T>(
      context: currentContext!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );
  }

  static Future<T?> showNavigationDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    if (currentContext == null) return Future.value(null);
    return showDialog<T>(
      context: currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  static String? getCurrentRoute() {
    if (currentContext == null) return null;
    final GoRouter router = GoRouter.of(currentContext!);
    return router.routerDelegate.currentConfiguration.fullPath;
  }

  static bool currentRouteRequiresAuth() {
    final currentRoute = getCurrentRoute();
    if (currentRoute == null) return false;
    return RouteConfig.requiresAuth(currentRoute);
  }

  static void logNavigation(String action, String route) {
    if (currentContext != null) {
      debugPrint('Navigation: $action -> $route');
    }
  }
}
