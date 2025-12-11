class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - Update this with your backend server URL
  static const String _baseUrl = "http://127.0.0.1:5000/v1";
  static String get baseUrl => _baseUrl;

  // ===============================
  // AUTHENTICATION ENDPOINTS
  // ===============================
  static const String signup = "/auth/signup";
  static const String login = "/auth/login";
  static const String forgotPassword = "/auth/forgot-password";
  static const String verifyOtp = "/auth/verify-otp";
  static const String resetPassword = "/auth/reset-password";
  static const String refreshToken = "/auth/refresh-token";
  static const String logout = "/auth/logout";

  // ===============================
  // USER PROFILE ENDPOINTS
  // ===============================
  static const String userProfile = "/user/profile";
  static const String updateProfile = "/user/profile";
  static const String uploadProfileImage = "/user/profile/image";

  // ===============================
  // ASSESSMENT ENDPOINTS
  // ===============================
  static const String createAssessment = "/assessments";
  static const String getAssessment = "/assessments"; // /{assessmentId}
  static const String assessmentHistory = "/assessments/history";
  static const String latestAssessment = "/assessments/latest";

  // ===============================
  // ACTION PLAN ENDPOINTS
  // ===============================
  static const String actionPlan = "/action-plans";
  static const String taskDetails = "/action-plans/tasks"; // /{taskId}
  static const String updateTaskStatus = "/action-plans/tasks"; // /{taskId}/status
  static const String updateTaskNotes = "/action-plans/tasks"; // /{taskId}/notes
  static const String tasksByCategory = "/action-plans/tasks/category"; // /{category}

  // ===============================
  // DOCUMENT ENDPOINTS
  // ===============================
  static const String generateLetter = "/documents/generate";
  static const String uploadDocument = "/documents/upload";
  static const String documents = "/documents";
  static const String getDocument = "/documents"; // /{documentId}
  static const String downloadDocument = "/documents"; // /{documentId}/download
  static const String deleteDocument = "/documents"; // /{documentId}
  static const String shareDocument = "/documents"; // /{documentId}/share

  // ===============================
  // NOTIFICATION ENDPOINTS
  // ===============================
  static const String notifications = "/notifications";
  static const String markNotificationRead = "/notifications"; // /{notificationId}/read
  static const String markAllNotificationsRead = "/notifications/read-all";
  static const String deleteNotification = "/notifications"; // /{notificationId}
  static const String notificationSettings = "/notifications/settings";
  static const String updateNotificationSettings = "/notifications/settings";

  // ===============================
  // SUBSCRIPTION ENDPOINTS
  // ===============================
  static const String subscriptionPlans = "/subscriptions/plans";
  static const String currentSubscription = "/subscriptions/current";
  static const String subscribe = "/subscriptions/subscribe";
  static const String cancelSubscription = "/subscriptions/cancel";

  // ===============================
  // SUPPORT ENDPOINTS
  // ===============================
  static const String faq = "/support/faq";
  static const String createTicket = "/support/tickets";
  static const String userTickets = "/support/tickets";
  static const String ticketDetails = "/support/tickets"; // /{ticketId}
  static const String addTicketMessage = "/support/tickets"; // /{ticketId}/messages
  static const String contactUs = "/support/contact";

  // ===============================
  // DASHBOARD ENDPOINTS
  // ===============================
  static const String dashboard = "/dashboard";
  static const String dashboardStatistics = "/dashboard/statistics";

  // ===============================
  // SETTINGS ENDPOINTS
  // ===============================
  static const String settings = "/settings";
  static const String updateSettings = "/settings";
  static const String changePassword = "/settings/change-password";
  static const String deleteAccount = "/settings/account";

  // ===============================
  // MISCELLANEOUS ENDPOINTS
  // ===============================
  static const String appVersion = "/app/version";
  static const String healthCheck = "/health";

  // ===============================
  // DEVICE ENDPOINTS
  // ===============================
  static const String registerDevice = "/devices/register";
  static const String unregisterDevice = "/devices"; // /{deviceId}
}
