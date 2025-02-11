class OtpVerifyRequest {
  final String mobile;
  final int otp;
  OtpVerifyRequest({
    required this.mobile,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile,
      "otp": otp,
    };
  }
}
