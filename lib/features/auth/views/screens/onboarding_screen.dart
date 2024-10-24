import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/features/auth/views/screens/signup_screen.dart';

import '../../../../core/theme/app_colors.dart';
import '../../bloc/intro/nextpage_event.dart';
import '../../bloc/intro/slider_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SliderBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorPallete.ceruleanBlue, // Cerulean Blue
                    ColorPallete.navyBlue, // Navy Blue
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Top-right corner image
            Positioned(
              top: 10,
              right: -45,
              child: Image.asset(
                'assets/images/hand.png', // Add your image asset here
                height: 97,
                width: 281,
              ),
            ),
            // Skip button at top-left corner
            Positioned(
              top: 16,
              left: 16,
              child: TextButton(
                onPressed: () {
                  // Skip to the last page
                  _pageController.jumpToPage(2);
                },
                child: Row(
                  children: [
                    Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.double_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<SliderBloc, SliderState>(
                    builder: (context, state) {
                      return PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          context.read<SliderBloc>().add(NextPageEvent());
                        },
                        children: [
                          _buildPage(
                            title: "Challenge Your Mind",
                            description: "Get a new creative question every day & learn something new daily!",
                            imagePath: 'assets/images/intro_icon1.png',
                          ),
                          _buildPage(
                            title: "Automatic\nAttendance Tracking",
                            description: "Just log in and out each day, and we’ll handle the rest.",
                            imagePath: 'assets/images/intro_icon2.png',
                          ),
                          _buildPage(
                            title: "Track Your Child’s\nProgress Effortlessly",
                            description: "Get weekly, monthly, and yearly report cards with detailed insights.",
                            imagePath: 'assets/images/intro_icon3.png',
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Next button at the bottom
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final currentPage = _pageController.page?.toInt() ?? 0;
                            if (currentPage < 2) {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }else{
                              Get.off(() => SignupScreen());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0), // Increase the radius
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each page
  Widget _buildPage({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main image
        SizedBox(height: 50),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color to stand out on gradient
          ),
        ),
        SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8), // Lighter text for description
          ),

        ),
        SizedBox(height: 32),
        Image.asset(imagePath),
      ],
    );
  }
}
