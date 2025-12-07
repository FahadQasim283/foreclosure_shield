import 'package:flutter/foundation.dart';
import 'route_names.dart';

class RouteConfig {
  RouteConfig._();

  /// All authenticated routes that require user login
  static const Set<String> _authenticatedRoutes = {
    RouteNames.mainTab,
    '${RouteNames.mainTab}/${RouteNames.home}',
  };

  /// All public routes that don't require authentication
  static const Set<String> _publicRoutes = {
    RouteNames.splash,
    RouteNames.getStarted,
    RouteNames.onboarding,
  };

  /// Routes that should not be accessible when user is already authenticated
  static const Set<String> _guestOnlyRoutes = {RouteNames.login, RouteNames.signup};

  /// Routes that can be accessed from deep links
  static const Set<String> _deepLinkableRoutes = {
    RouteNames.mainTab,
    '${RouteNames.mainTab}/${RouteNames.home}',
  };

  /// Check if a route requires authentication
  static bool requiresAuth(String route) {
    return _authenticatedRoutes.contains(route);
  }

  /// Check if a route is public (doesn't require auth)
  static bool isPublicRoute(String route) {
    return _publicRoutes.contains(route);
  }

  /// Check if a route should only be accessible to guests (non-authenticated users)
  static bool isGuestOnlyRoute(String route) {
    return _guestOnlyRoutes.contains(route);
  }

  /// Check if a route can be accessed via deep links
  static bool isDeepLinkable(String route) {
    return _deepLinkableRoutes.contains(route);
  }

  /// Get the initial route based on authentication status
  static String getInitialRoute({required bool isAuthenticated, bool hasSeenOnboarding = true}) {
    if (!hasSeenOnboarding) {
      return RouteNames.onboarding;
    }

    if (isAuthenticated) {
      return RouteNames.mainTab;
    }

    return RouteNames.login;
  }

  /// Validate route path format
  static bool isValidRoutePath(String path) {
    if (kDebugMode) {
      // In debug mode, perform more thorough validation
      if (!path.startsWith('/')) {
        debugPrint('Invalid route path: $path (must start with /)');
        return false;
      }

      if (path.contains('//')) {
        debugPrint('Invalid route path: $path (contains double slashes)');
        return false;
      }

      if (path.endsWith('/') && path.length > 1) {
        debugPrint('Invalid route path: $path (should not end with /)');
        return false;
      }
    }

    return path.startsWith('/') &&
        !path.contains('//') &&
        (path.length == 1 || !path.endsWith('/'));
  }

  /// Get all route names for testing or debugging
  static List<String> get allRoutes {
    return [..._authenticatedRoutes, ..._publicRoutes].toList()..sort();
  }
}
