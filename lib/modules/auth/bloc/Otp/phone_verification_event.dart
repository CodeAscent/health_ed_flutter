abstract class PhoneVerificationEvent {}

class SendOtpEvent extends PhoneVerificationEvent {
  final String phoneNumber;

  SendOtpEvent(this.phoneNumber);
}

class VerifyOtpEvent extends PhoneVerificationEvent {
  final String otpCode;

  VerifyOtpEvent(this.otpCode);
}

// phone_verification_state.dart
abstract class PhoneVerificationState {}

class PhoneInputState extends PhoneVerificationState {}

class OtpInputState extends PhoneVerificationState {}

class OtpSentState extends PhoneVerificationState {
  final String phoneNumber;
  OtpSentState(this.phoneNumber);
}
