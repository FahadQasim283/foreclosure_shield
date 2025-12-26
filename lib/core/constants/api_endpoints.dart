class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - Update this with your backend server URL
  static const String _baseUrl = "https://foreclosure-shield-backend.onrender.com/api";
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
  static const String userProfile = "/users/profile";
  static const String updateProfile = "/users/profile";
  static const String uploadProfileImage = "/users/profile/image";
  static String getUserById(String userId) => "/users/$userId";

  // ===============================
  // ASSESSMENT ENDPOINTS
  // ===============================
  static const String createAssessment = "/assessment";
  static String getAssessment(String assessmentId) => "/assessment/$assessmentId";
  static const String assessmentHistory = "/assessment/history";
  static const String latestAssessment = "/assessment/latest";

  // ===============================
  // ACTION PLAN ENDPOINTS
  // ===============================
  static const String actionPlan = "/action-plan";
  static const String allTasks = "/action-plan/tasks";
  static String getTaskDetails(String taskId) => "/action-plan/task/$taskId";
  static String updateTaskStatus(String taskId) => "/action-plan/task/$taskId/status";
  static String updateTaskNotes(String taskId) => "/action-plan/task/$taskId/notes";

  // ===============================
  // DOCUMENT ENDPOINTS
  // ===============================
  static const String generateDocument = "/documents/generate";
  static const String uploadDocument = "/documents/upload";
  static const String documents = "/documents";
  static String getDocument(String documentId) => "/documents/$documentId";
  static String downloadDocument(String documentId) => "/documents/$documentId/download";
  static String deleteDocument(String documentId) => "/documents/$documentId";
  static String shareDocument(String documentId) => "/documents/$documentId/share";

  // ===============================
  // NOTIFICATION ENDPOINTS
  // ===============================
  static const String allNotifications = "/notification/all";
  static const String notificationUnreadCount = "/notifications/unread-count";
  static String markNotificationRead(String notificationId) => "/notifications/$notificationId/read";
  static const String markAllRead = "/notifications/mark-all-read";
  static String deleteNotification(String notificationId) => "/notifications/$notificationId";

  // ===============================
  // SUBSCRIPTION ENDPOINTS
  // ===============================
  static const String subscriptionPlans = "/subscription/plans";
  static const String currentSubscription = "/subscription/current";
  static const String subscribe = "/subscription/subscribe";
  static const String cancelSubscription = "/subscription/cancel";

  // ===============================
  // SUPPORT ENDPOINTS
  // ===============================
  static const String faq = "/support/faq";
  static const String createTicket = "/support/ticket";
  static const String supportTickets = "/support/tickets";
  static String getTicketDetails(String ticketId) => "/support/ticket/$ticketId";
  static String addTicketMessage(String ticketId) => "/support/ticket/$ticketId/message";
  static const String contactUs = "/support/contact";

  // ===============================
  // DASHBOARD ENDPOINTS
  // ===============================
    static const String dashboardSummary = "/dashboard";
  static const String dashboardStatistics = "/dashboard/statistics";

  // ===============================
  // SETTINGS ENDPOINTS
  // ===============================
  static const String settings = "/settings";
  static const String updateSettings = "/settings";
  static const String changePassword = "/settings/change-password";
  static const String deleteAccount = "/settings/account";

  // ===============================
  // MISCELLANEOUS ENDPOINTSdelete-account";

  // ===============================
  // MISCELLANEOUS ENDPOINTS
  // ===============================
  static const String healthCheck = "/";
  static const String appStatus = "/misc/status";

  // ===============================
  // DEVICE ENDPOINTS
  // ===============================
  static const String registerDevice = "/device/register";
  static const String allDevices = "/device/all";
  static String unregisterDevice(String deviceId) => "/device/$deviceId";
}
