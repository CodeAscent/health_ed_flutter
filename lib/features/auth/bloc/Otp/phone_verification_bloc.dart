import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/features/auth/bloc/Otp/phone_verification_event.dart';

class PhoneVerificationBloc extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  PhoneVerificationBloc() : super(PhoneInputState());

  @override
  Stream<PhoneVerificationState> mapEventToState(PhoneVerificationEvent event) async* {
    if (event is SendOtpEvent) {
      yield OtpSentState(event.phoneNumber);
    } else if (event is VerifyOtpEvent) {
      // Handle OTP verification logic here
      // If OTP is valid, navigate to another page or success state
    }
  }
}
