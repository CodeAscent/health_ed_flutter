class RegisterResponse {
  final bool success;
  final String message;
  final RegisterData data;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.data,
  });
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      message: json['message'],
      data: RegisterData.fromJson(json['data']),
    );
  }
}

class RegisterData {
  final int currentStep;

  RegisterData({
    required this.currentStep,
  });

  // Factory constructor to create an instance from JSON
  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      currentStep: json['currentStep'],
    );
  }
}
