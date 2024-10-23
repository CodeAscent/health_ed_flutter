import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/features/auth/views/screens/login_screen.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/features/auth/views/screens/signup_screen.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Adding a 3-second delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if the token is present in local storage
    String? token = await LocalStorage.getString('token');

    if (token != null) {
      // Navigate to LoginScreen if the token is available
      Get.off(() => const LoginScreen());
    } else {
      // Navigate to SignUpScreen if the token is null
      Get.off(() => OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorPallete.ceruleanBlue, // Cerulean Blue
              ColorPallete.navyBlue, // Navy Blue
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/icon.png', // Replace with your image path
            width: 150, // Adjust size as needed
            height: 150,
          ),
        ),
      ),
    );
  }
}
