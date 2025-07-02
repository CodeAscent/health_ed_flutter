import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/modules/auth/models/request/LoginRequest.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/signupscreennew.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/verify_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late List<FocusNode> focusNodes;
  final _mobileNoController = TextEditingController();
  List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());
  String otp = "";

  // Timer related variables
  late int secondsRemaining;
  bool enableResend = false;
  late Timer timer;

  // bool isTermsAccepted = false; // Added for checkbox

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (_) => FocusNode());
    secondsRemaining = 30;
    startTimer();
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((node) => node.dispose());
    timer.cancel();
    super.dispose();
  }

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

  void resendOtp() {
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
    startTimer();
    // Add resend OTP logic here if needed
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
            if (state.loginResponse.data.currentStep == 0) {
              customSnackbar(
                "You are not registered. Please sign up to continue.",
                ContentType.failure,
              );
            } else {
              customSnackbar(
                  "${state.loginResponse.message}", ContentType.success);
              Get.to(() => VerifyOtpScreen(_mobileNoController.text));
            }
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoader();
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/bg/auth_bg.png'),
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
                              Text('Enter Phone Number',
                                  style: kCustomHeadingTS()),
                              SizedBox(height: 6),
                              Text('We will send an Otp verification to you'),
                              SizedBox(height: 30),
                              CustomTextFieldWithPrefix(
                                controller: _mobileNoController,
                                hintText: '',
                              ),
                              SizedBox(height: 20),

                              // // Terms and Conditions Checkbox
                              // Row(
                              //   children: [
                              //     Checkbox(
                              //       value: isTermsAccepted,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           isTermsAccepted = value ?? false;
                              //         });
                              //       },
                              //     ),
                              //     Expanded(
                              //       child: RichText(
                              //         text: TextSpan(
                              //           style: TextStyle(
                              //               color: Colors.black, fontSize: 14),
                              //           children: [
                              //             TextSpan(text: 'I agree to the '),
                              //             TextSpan(
                              //               text: 'Terms & Conditions',
                              //               style: TextStyle(
                              //                   color: ColorPallete.primary,
                              //                   decoration:
                              //                       TextDecoration.underline),
                              //               recognizer: TapGestureRecognizer()
                              //                 ..onTap = () {
                              //                   // Navigate or show T&C page
                              //                   Get.to(() => TermsScreen());
                              //                 },
                              //             ),
                              //             TextSpan(text: ' and '),
                              //             TextSpan(
                              //               text: 'Privacy Policy',
                              //               style: TextStyle(
                              //                   color: ColorPallete.primary,
                              //                   decoration:
                              //                       TextDecoration.underline),
                              //               recognizer: TapGestureRecognizer()
                              //                 ..onTap = () {
                              //                   // Navigate or show Privacy Policy page
                              //                   Get.to(() =>
                              //                       PrivacyPolicyScreen());
                              //                 },
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              SizedBox(height: 30),
                              CustomGradientButton(
                                label: 'Send me the code',
                                onTap: () {
                                  // if (!isTermsAccepted) {
                                  //   customSnackbar(
                                  //       "Please accept Terms & Conditions and Privacy Policy",
                                  //       ContentType.failure);
                                  //   return;
                                  // }

                                  if (_mobileNoController.text.length >= 10) {
                                    final loginRequest = LoginRequest(
                                        mobile: _mobileNoController.text);
                                    context.read<AuthBloc>().add(
                                        AuthLoginRequested(
                                            loginRequest: loginRequest));
                                  } else {
                                    customSnackbar(
                                        "Please enter a valid mobile number",
                                        ContentType.failure);
                                  }
                                },
                              ),
                              SizedBox(height: 40),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(text: "New user? "),
                                      TextSpan(
                                        text: "Signup",
                                        style: TextStyle(
                                          color: ColorPallete.primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to signup screen
                                            Get.off(() => SignupScreenNew());
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
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

// Dummy placeholder screens for navigation
class TermsScreen extends StatelessWidget {
  final TextStyle headingStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final TextStyle bodyStyle = TextStyle(fontSize: 16, height: 1.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms of service:', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'The list of terms of service (or “Terms”) to be read carefully by the user before using The Dhwani app',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('• Link to third party websites', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'Our Service may contain links to third-party web sites or services that are not owned or controlled by The Dhwani.\n'
              'The Dhwani has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that The Dhwani shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.\n'
              'We strongly advise you to read the terms and conditions and privacy policies of any third-party web sites or services that you visit.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('• Termination of service', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'We may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.\n\n'
              'All provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('• Modification of terms', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will try to provide at least 10 days notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.\n'
              'By continuing to access or use our Service after those revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, please stop using the Service.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('• Jurisdiction', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'All the Terms shall be governed and construed in accordance with the laws of Odisha, India, without regard to its conflict of law provisions. All terms will come under Bhubaneswar  jurisdiction only.\n'
              'If you have any queries , please write to us at archansthedhwani@gmail.com',
              style: bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  final TextStyle headingStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final TextStyle bodyStyle = TextStyle(fontSize: 16, height: 1.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy\nEffective Date: 1 April 2025',
                style: headingStyle),
            SizedBox(height: 16),
            Text('1. Introduction', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'Welcome to The Dhwani application ("we," "our," "us"). We are committed to protecting your privacy and ensuring a safe and enjoyable learning experience for children. This Privacy Policy explains how we collect, use, and safeguard your information when you use our subscription-based speech therapy application designed for kids with issues of delayed speech and language.\n'
              'By using our App, you agree to the terms of this Privacy Policy. If you do not agree, please do not use the App. The privacy policy does not apply to the third party / online mobile store  from which the app is installed or payments made.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('2. Information We Collect', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'We collect the following types of information:\n\n'
              '(a) Personal Information:\n'
              '• Parent/guardian\'s name and contact details (email, phone number, address).\n'
              '• Payment details (processed securely through third-party payment providers).\n\n'
              '(b) Child’s Information:\n'
              '• First name or nickname\n'
              '• Gender\n'
              '• Family details\n'
              '• Age and learning preferences (language).\n\n'
              '(c) Usage Information:\n'
              '• Interaction with the App (e.g., progress, preferences, learning activities).\n'
              '• Device information (IP address, operating system, browser type).\n\n'
              '(d) Cookies and Tracking Technologies:\n'
              'We may use cookies to enhance user experience, analyze trends, and improve our services. Parents can manage cookie settings via their device settings.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('3. How We Use Your Information', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'We use the collected data to:\n'
              '• Provide and personalize the learning experience.\n'
              '• Process subscriptions and payments.\n'
              '• Improve and enhance the App’s features.\n'
              '• Communicate with parents/guardians regarding updates and support.\n'
              '• Ensure the security and compliance of our services.\n'
              '• Push Notification - We may request to send you push notifications regarding your account or the App. If you wish to opt-out from receiving these types of communications, you may turn them off in your device’s settings.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('4. Sharing and Disclosure', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'We do not sell, trade, or rent any personal information. However, we may share information with:\n'
              '• Service Providers: Third-party payment processors and analytics providers who help us operate the App.\n'
              '• Legal Compliance: If required by law, such as responding to legal requests or protecting our rights.\n'
              '• Business Transfers: In case of a merger, sale, or transfer of assets, your information may be part of the transferred assets.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('5. Data Security', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'We take reasonable measures to protect your information from unauthorized access, disclosure, or loss. However, no method of transmission over the internet is 100% secure, and we encourage users to safeguard their credentials.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('6. Parental Controls & Rights', style: headingStyle),
            SizedBox(height: 8),
            Text(
              '• Parents have the right to review, update, or delete their child’s data.\n'
              '• Parents can opt out of non-essential data collection.\n'
              '• To request data deletion or updates, contact us at archanasthedhwani@gmail.com.\n\n'
              'Usage of App:- \n'
              'This app is to be strictly used under parental guidance. The app cannot be given directly to the children for use.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('7. Third-Party Links', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'The App may contain links to third-party websites or services. We are not responsible for their privacy practices and encourage you to review their policies.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('8. Changes to This Privacy Policy', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'We may update this policy from time to time. Any changes will be posted within the App, and continued use of the App signifies acceptance of the changes.',
              style: bodyStyle,
            ),
            SizedBox(height: 16),
            Text('9. Contact Us', style: headingStyle),
            SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about this Privacy Policy, please contact us at:\n'
              'The Dhwani\n'
              'archanasthedhwani@gmail.com\n\n'
              'Thank you for trusting The Dhwani  for your child’s future!',
              style: bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}
