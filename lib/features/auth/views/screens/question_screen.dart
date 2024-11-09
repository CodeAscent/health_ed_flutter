import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/features/navigation/views/screens/MainScreen.dart';

import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/intro/slider_bloc.dart';
import '../../widgets/congrats_popup.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SliderBloc(),
        child:
      Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/bg/questionBg.png',
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTransparentContainer(
                  child:
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppBackButton(),
                                SizedBox(width: 6), // Space between button and progress bar
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0), // Set radius
                                    child: LinearProgressIndicator(
                                      minHeight: 8,
                                      value: 0.05, // Adjust progress
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(ColorPallete.primary),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10), // Add some space
                                Text(
                                  "1/20",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 10), // Adjust space between text and question
                            // Question with Sound Icon
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/volume_up.png', // Path to your image asset
                                  width: 24, // Set width as needed
                                  height: 24, // Set height as needed
                                ),
                                SizedBox(width: 8), // Space between icon and question
                                Expanded(
                                  child: Text(
                                    "What comes next in the sequence: 2, 4, 6, 8, ___?",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Options List
                            Column(
                              children: [
                                buildOptionTile("A. 09", 1),
                                buildOptionTile("B. 10", 2),
                                buildOptionTile("C. 09", 3),
                                buildOptionTile("D. 06", 4),
                                buildOptionTile("E. 12", 5),
                              ],
                            ),
                          ],
                        ),
                        Spacer(), // Pushes the buttons to the bottom
                        // Bottom Navigation
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Previous Button with white background and blue border
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle previous
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 15), // Removed horizontal padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: ColorPallete.primary), // Blue border
                                    ),
                                    backgroundColor: Colors.white, // White background
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center content inside the button
                                    children: [
                                      Icon(Icons.arrow_back_ios_new_rounded, color: ColorPallete.primary), // Blue icon
                                      SizedBox(width: 5),
                                      Text(
                                        "Previous",
                                        style: TextStyle(color: ColorPallete.primary), // Blue text color
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10), // Space between the two buttons
                              // Next Button with blue background
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.dialog(
                                      CongratsPopup(level: '2'), // Adjust the level as needed
                                    );

                                    // Delay the navigation by 3 seconds
                                    Future.delayed(Duration(seconds: 3), () {
                                      Get.back(); // Closes the dialog
                                      Get.to(MainScreen()); // Replace with your new screen
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 15), // Removed horizontal padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), // 20 radius for the button
                                    ),
                                    backgroundColor: ColorPallete.primary, // Blue background
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center content inside the button
                                    children: [
                                      Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white), // White text color
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white), // White icon
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),

                ),
              ],
            ),
          ),
        ),
      ),
    ));

  }


  Widget buildOptionTile(String optionText, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: selectedOption == value ? Colors.white : Colors.transparent, // Highlight selected option
          borderRadius: BorderRadius.circular(14), // Rounded corners for the card
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 10), // Add margin between options
        child: Text(
          optionText,
          style: TextStyle(
            fontSize: 18,
            color: selectedOption == value ? Colors.black : Colors.black87, // Slightly different color for selected
          ),
        ),
      ),
    );
  }
}
