class SessionModel {
  final String? sessionId;
  final String? code;
  final String? message;
  final String deviceId;

  SessionModel({
    this.sessionId,
    this.code,
    this.message,
    required this.deviceId,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['session_id'],
      code: json['code'],
      message: json['message'],
      deviceId: json['device_id'],
    );
  }
}
