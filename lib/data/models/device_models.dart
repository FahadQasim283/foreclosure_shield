// ===============================
// DEVICE MODEL
// ===============================
class Device {
  final String id;
  final String deviceToken;
  final String platform;
  final String? deviceName;
  final String? deviceModel;
  final DateTime registeredAt;
  final DateTime lastActiveAt;

  Device({
    required this.id,
    required this.deviceToken,
    required this.platform,
    this.deviceName,
    this.deviceModel,
    required this.registeredAt,
    required this.lastActiveAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      deviceToken: json['deviceToken'] as String,
      platform: json['platform'] as String,
      deviceName: json['deviceName'] as String?,
      deviceModel: json['deviceModel'] as String?,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
    );
  }
}

// ===============================
// REQUEST MODELS
// ===============================

class RegisterDeviceRequest {
  final String deviceToken;
  final String platform;
  final String? deviceName;
  final String? deviceModel;
  final String? osVersion;

  RegisterDeviceRequest({
    required this.deviceToken,
    required this.platform,
    this.deviceName,
    this.deviceModel,
    this.osVersion,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceToken': deviceToken,
      'platform': platform,
      if (deviceName != null) 'deviceName': deviceName,
      if (deviceModel != null) 'deviceModel': deviceModel,
      if (osVersion != null) 'osVersion': osVersion,
    };
  }
}

// ===============================
// RESPONSE MODELS
// ===============================

class RegisterDeviceResponse {
  final Device device;

  RegisterDeviceResponse({required this.device});

  factory RegisterDeviceResponse.fromJson(Map<String, dynamic> json) {
    return RegisterDeviceResponse(device: Device.fromJson(json));
  }
}

class UnregisterDeviceResponse {
  final bool success;
  final String deviceId;

  UnregisterDeviceResponse({required this.success, required this.deviceId});

  factory UnregisterDeviceResponse.fromJson(Map<String, dynamic> json) {
    return UnregisterDeviceResponse(
      success: json['success'] as bool,
      deviceId: json['deviceId'] as String,
    );
  }
}
