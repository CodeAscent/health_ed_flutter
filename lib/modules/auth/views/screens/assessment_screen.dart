import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/AssessmentPaymentPage.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/question_screen.dart';

import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/assessment/AssessmentEvent.dart';

// Limited Offer
// Recommended


class AssessmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppGreyBackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Choose Your Assessment",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Once the speech assessment is done, the user will be directed to daily activity.\n[Activities for first 3 days will be free]",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                // Image/Icon placeholder
                Image.asset('assets/images/assessment.png', height: 150), // Replace with your image
                SizedBox(height: 30),
                // Card for buttons with background image
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Optional opacity
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage('assets/images/assessmentButtonBg.png'), // Replace with your image path
                      fit: BoxFit.cover, // Adjust the image to cover the entire container
                    ),
                  ),
                  padding: const EdgeInsets.all(14), // You can adjust the padding as needed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns items in the column
                    children: [
                      Text(
                        'Algorithm Based Speech Assessment*', // Replace with your desired text
                        style: TextStyle(
                          fontSize: 16, // You can adjust the font size
                          fontWeight: FontWeight.bold, // You can adjust the font weight
                          color: Colors.black, // You can adjust the text color
                        ),
                      ),
                      SizedBox(height: 15,),
                      CustomGradientButton(
                        label: 'Start now! (Rs 500 Free)',
                        onTap: (){ Get.off(() => QuestionScreen());},
                      ),
                         SizedBox(height: 5,),
                        Text(
                        '*Based on The Dhwani’s proprietary algorithm', // Replace with your desired text
                        style: TextStyle(
                          fontSize: 12, // You can adjust the font size
           // You can adjust the font weight
                          color: Colors.black, // You can adjust the text color
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: ColorPallete.disabled),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "OR",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: ColorPallete.disabled),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9), // Optional opacity
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage('assets/images/assessmentButtonBg.png'), // Replace with your image path
                      fit: BoxFit.cover, // Adjust the image to cover the entire container
                    ),
                  ),
                  padding: const EdgeInsets.all(20), // You can adjust the padding as needed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns items in the column
                    children: [
                      Text(
                        'Comprehensive Speech Assessment by Speech Therapist.', // Replace with your desired text
                        style: TextStyle(
                          fontSize: 16, // You can adjust the font size
                          fontWeight: FontWeight.bold, // You can adjust the font weight
                          color: Colors.black, // You can adjust the text color
                        ),
                      ),
                      SizedBox(height: 15,),
                      CustomGradientButton(
                        label: 'Pay & Start! (Rs 200)',
                        onTap: (){ 
                           Get.to(Assessmentpaymentpage());
                          },
                      ),
                       SizedBox(height: 5,),
                        Text(
                        '*Online speech assessment will be done within 36 hrs', // Replace with your desired text
                        style: TextStyle(
                          fontSize: 12, // You can adjust the font size
           // You can adjust the font weight
                          color: Colors.black, // You can adjust the text color
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
