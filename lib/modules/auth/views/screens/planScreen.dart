import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/AllPlanScreen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/FaqScreen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/UserSubscription.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/assessment_screen.dart';
import 'package:health_ed_flutter/modules/home/views/screens/home_screen.dart';
import 'package:health_ed_flutter/modules/navigation/views/screens/MainScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {


  final List<String> carouselImages = [
    'https://loremflickr.com/400/200?random=1',
    'https://loremflickr.com/400/200?random=2',
    'https://loremflickr.com/400/200?random=3',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine the assessment status
    String subtitleText = '';
    VoidCallback? onTapAction;
  var userData = LocalStorage.prefs.getString('userProfileData') != null
      ? jsonDecode(LocalStorage.prefs.getString('userProfileData')!)['user']
      : '';
         print(userData['subscriptionStatus']); 
  if (userData['onboardingScore'] == 0) {
  subtitleText = 'Start your child’s IQ assessment now';
  onTapAction = () => Get.to(() => AssessmentScreen());
} else if (userData['onboardingScore'] == 0&&userData['assessmentPaymentStatus'] == 'paid') {
  if (userData['isTeacherEvaluationCompleted'] == false) {
    subtitleText = 'Please wait. A teacher will visit and evaluate your child soon.';
    onTapAction = () {
      Get.snackbar(
        'Teacher Evaluation Pending',
        'A teacher will visit and evaluate your child soon. Please be patient.',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black,
      );
    };
  } else {
    subtitleText = 'Assessment completed. Score: ${userData['onboardingScore']}';
    onTapAction = () {
      Get.dialog(
        AlertDialog(
          title: Text('Assessment Completed'),
          content: Text(
            'Your onboarding score is: ${userData['onboardingScore']}',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    };
  }
} else {
  subtitleText =  'Your onboarding score is: ${userData['onboardingScore']}';
  onTapAction = () {
    Get.snackbar(
      'Assessment Completed',
       'Your onboarding score is: ${userData['onboardingScore']}',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
    );
  };
}


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: carouselImages.map((image) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(image, fit: BoxFit.cover),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: carouselImages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey.shade300,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      'Choose Your Assessment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(subtitleText),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: onTapAction,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildGridButton('Home', Icons.home, Color.fromARGB(255, 219, 67, 21),1,userData),
                  _buildGridButton('Get Pro', Icons.emoji_events, Color(0xFFF7CE45),2,userData),
                  _buildGridButton('How it Works', Icons.menu_book, Color(0xFF01D15F),3,userData),
                  _buildGridButton('FAQ', Icons.help, Color(0xFF5370C8),4,userData),
                ],
              ),
            ),

            SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Text(
                    'Contact us:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('dhiwani1234@gmail.com'),
                  Text('+91 7878473497'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(String title, IconData icon, Color color,int gridNo, userData) {

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: () {
          if(gridNo==1)
              Get.to(() => MainScreen());
          else if(gridNo==2)
              if(userData['subscriptionStatus']=="active")
              {
             Get.to(() => AllPlanScreen());
              }  else{
             Get.to(() => AllPlanScreen());
              }
 
          else if(gridNo==3)
              Get.to(() => AllPlanScreen());
          else if(gridNo==4)
              Get.to(() => FaqScreen());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
