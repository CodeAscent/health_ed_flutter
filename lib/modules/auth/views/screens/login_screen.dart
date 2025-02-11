import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/modules/auth/models/request/LoginRequest.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/verify_otp_screen.dart';


class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late List<FocusNode> focusNodes;
  final _mobileNoController = TextEditingController();
  List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
  String otp = "";

  // Timer related variables
  late int secondsRemaining;
  bool enableResend = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (_) => FocusNode());
    secondsRemaining = 30; // Set initial timer for 30 seconds
    startTimer();
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((node) => node.dispose());
    timer.cancel();
    super.dispose();
  }

  // Start the countdown timer for Resend OTP
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  // Handle Resend OTP logic
  void resendOtp() {
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
    startTimer();
    // Add your resend OTP event here
    // BlocProvider.of<PhoneVerificationBloc>(context).add(ResendOtpEvent(widget.phoneNumber));
  }




  @override
  Widget build(BuildContext context) {
    return Form(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            customSnackbar(state.message, ContentType.failure);
          }
          if (state is AuthLoginSuccess) {
            customSnackbar(state.message, ContentType.success);
            Get.to(() => VerifyOtpScreen(_mobileNoController.text));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoader();
          }

          return
            Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/bg/auth_bg.png',
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBackButton(color: Colors.white),
                          SizedBox(height: 6),
                          CustomTransparentContainer(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add Phone Number',
                                    style: kCustomHeadingTS(),
                                  ),
                                  SizedBox(height: 6),
                                  Text('We will send an Otp verification to you'),
                                  SizedBox(height: 30),
                                  CustomTextFieldWithPrefix(
                                    controller: _mobileNoController,
                                    hintText: '',
                                  ),

                                  SizedBox(height: 20),
                                  // Resend Button and Timer

                                  SizedBox(
                                    height: 30,
                                  ),
                                  CustomGradientButton(
                                    label: 'Send me the code',
                                      onTap: () {
                                        // Get.to(() =>  VerifyOtpScreen(_mobileNoController.text));
                                        if (_mobileNoController.text.length>=10) {
                                          final loginRequest = LoginRequest(
                                              mobile: _mobileNoController.text
                                          );
                                          context.read<AuthBloc>().add(AuthLoginRequested(loginRequest: loginRequest));
                                        }else{
                                          customSnackbar("Please enter a valid mobile number", ContentType.failure);
                                        }
                                      },
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )),
              ),
            );
        },
      ),
    );
  }

  TextStyle kCustomHeadingTS() {
    return TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
  }
}
