import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/auth/models/request/LoginRequest.dart';
import 'package:health_ed_flutter/modules/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/PlanScreen.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/login_screen.dart';
import 'package:health_ed_flutter/modules/navigation/views/screens/MainScreen.dart';

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
    await Future.delayed(const Duration(seconds: 6));
    // String? token = await LocalStorage.getString('userData');
    await AuthRepository().fetchUser();
    Get.off(() => MainScreen());
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
              ColorPallete.ceruleanBlue,
              ColorPallete.navyBlue,
            ],
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              height: 120,
              width: 170,
              "assets/images/logo.gif",
              fit: BoxFit.fill,
            ),
            Text(
              "The Dhwani",
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        )),
      ),
    );
  }
}
