import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/AssessmentPaymentPage.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/question_screen.dart';

import '../../../../core/utils/custom_widgets.dart';

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
                  "Speech & Language Assesment",
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
                SizedBox(height: 100),
                // Image/Icon placeholder
                Image.asset('assets/images/assessment.png',
                    height: 150), // Replace with your image
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
                      image: AssetImage(
                          'assets/images/assessmentButtonBg.png'), // Replace with your image path
                      fit: BoxFit
                          .cover, // Adjust the image to cover the entire container
                    ),
                  ),
                  padding: const EdgeInsets.all(
                      14), // You can adjust the padding as needed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Aligns items in the column
                    children: [
                      Text(
                        'Algorithm Based Speech Assessment*', // Replace with your desired text
                        style: TextStyle(
                          fontSize: 16, // You can adjust the font size
                          fontWeight:
                              FontWeight.bold, // You can adjust the font weight
                          color: Colors.black, // You can adjust the text color
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomGradientButton1(
                        label: 'Start now! (Rs 500 Free)',
                        onTap: () {
                          Get.off(() => QuestionScreen());
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
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
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Divider(color: ColorPallete.disabled),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Text(
//                         "OR",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     ),
//                     Expanded(
//                       child: Divider(color: ColorPallete.disabled),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9), // Optional opacity
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 5,
//                         blurRadius: 7,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                     image: DecorationImage(
//                       image: AssetImage(
//                           'assets/images/assessmentButtonBg.png'), // Replace with your image path
//                       fit: BoxFit
//                           .cover, // Adjust the image to cover the entire container
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(
//                       20), // You can adjust the padding as needed
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment
//                         .spaceBetween, // Aligns items in the column
//                     children: [
//                       Text(
//                         'Comprehensive Speech Assessment by Speech Therapist.', // Replace with your desired text
//                         style: TextStyle(
//                           fontSize: 16, // You can adjust the font size
//                           fontWeight:
//                               FontWeight.bold, // You can adjust the font weight
//                           color: Colors.black, // You can adjust the text color
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       CustomGradientButton(
//                         label: 'Pay & Start! (Rs 399)',
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text('Refund Policy'),
//                               content: SingleChildScrollView(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'The following pointers are applicable for the Users who are paying for any services:-\n',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     Text(
//                                       '''
// • There will be no refund for any of the subscription availed (Monthly or Annually)
// • The refund for Comprehensive Assessment Plan will only be applicable if the assessment is not done and the report is not provided within 15 days of payment received
// • The refund for online speech therapy will be provided for the unused sessions only after 15 days of the expired date of the sessions. The refund will be processed only after the communication is received from the users over mail to archanasthedhwani@gmail.com  (Ex- If for a month 16 sessions are scheduled from 1 May 2025 to 31 May 2025, only 12 are availed, the refund will be provided after 15 June 2025)
// • A single promotional code can be used once and cannot be clubbed with any other offers
// • For all payments an additional 18% GST will be charged
// • All payments to be done through Razorpay
// • All disputes are subjected to Bhubaneswar jurisdiction only
// • Cancellation of service can be done by writing to us at archanasthedhwani@gmail.com
// ''',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: Text('Cancel'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.pop(context); // Close dialog
//                                     Get.to(Assessmentpaymentpage()); // Navigate
//                                   },
//                                   child: Text('Agree'),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         '*Online speech assessment will be done within 36 hrs', // Replace with your desired text
//                         style: TextStyle(
//                           fontSize: 12, // You can adjust the font size
//                           // You can adjust the font weight
//                           color: Colors.black, // You can adjust the text color
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
