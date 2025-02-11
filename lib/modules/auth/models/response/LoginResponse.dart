class LoginResponse {
  final bool success;
  final String message;
  final OtpData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: OtpData.fromJson(json['data']),
    );
  }
}

class OtpData {
  final int currentStep;
  final int otp;

  OtpData({
    required this.currentStep,
    required this.otp,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      currentStep: json['currentStep'],
      otp: json['otp'],
    );
  }
}
