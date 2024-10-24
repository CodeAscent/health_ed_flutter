import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/utils/custom_constants.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/features/auth/views/screens/login_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  VerifyOtpScreen(this.phoneNumber);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late List<FocusNode> focusNodes;
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

  // Check for the first unfilled box and focus it
  void _focusNextEmptyField() {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        FocusScope.of(context).requestFocus(focusNodes[i]);
        break;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            customSnackbar(state.message, ContentType.failure);
          }
          if (state is AuthRegisterSuccess) {
            customSnackbar(state.message, ContentType.success);
            Get.to(() => LoginScreen());
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoader();
          }

          return Scaffold(
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
                        AppBackButton(),
                        SizedBox(height: 6),
                        CustomTransparentContainer(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Verify Your Number',
                                  style: kCustomHeadingTS(),
                                ),
                                SizedBox(height: 6),
                                Text('We have sent an Otp verification to you'),
                                SizedBox(height: 30),
                                // OTP Input Fields
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(4, (index) {
                                    return SizedBox(
                                      width: 60,
                                      child: TextField(
                                        controller: controllers[index],
                                        focusNode: focusNodes[index],
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        decoration: InputDecoration(
                                          counterText: '',
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                          fillColor: Colors.transparent, // Transparent background color
                                          filled: true, // Apply the fillColor
                                        ),
                                        onChanged: (value) {
                                          if (value.length == 1) {
                                            // Move to the next unfilled field
                                            _focusNextEmptyField();
                                          } else if (value.isEmpty && index > 0) {
                                            // Move to the previous field if cleared
                                            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                                          }
                                        },
                                        onTap: () {
                                          // If user taps on any field, focus the first unfilled box
                                          if (controllers[index].text.isEmpty) {
                                            _focusNextEmptyField();
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 20),
                                // Resend Button and Timer
                                Align(
                                  child: Column(children: [
                                    TextButton(
                                      onPressed: enableResend ? resendOtp : null,
                                      child: Text('Resend code', style: TextStyle(color: enableResend ? ColorPallete.primary:ColorPallete.disabled)),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min, // Keeps the button size compact
                                      children: [
                                        Icon(
                                          Icons.timer_outlined, // Choose the desired icon
                                          color:ColorPallete.disabled,
                                        ),
                                        SizedBox(width: 8), // Adds some spacing between the icon and text
                                        Text(
                                          secondsRemaining > 0 ? '00:$secondsRemaining' : '00:00',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomGradientButton(
                                  label: 'Continue',
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