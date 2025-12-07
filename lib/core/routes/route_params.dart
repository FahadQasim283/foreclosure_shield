class RouteParams {
  RouteParams._();

  static const String cameraId = 'cameraId';
  static const String detectionId = 'detectionId';
  static const String notificationId = 'notificationId';
  static const String userId = 'userId';

  static bool isValidCameraId(String? id) {
    return id != null && id.isNotEmpty && RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id);
  }

  static bool isValidDetectionId(String? id) {
    return id != null && id.isNotEmpty && RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id);
  }

  static bool isValidNotificationId(String? id) {
    return id != null && id.isNotEmpty && RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id);
  }

  static bool isValidUserId(String? id) {
    return id != null && id.isNotEmpty && RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id);
  }
}
