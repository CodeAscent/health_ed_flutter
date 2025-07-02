import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/AllPlanScreen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/ContactUs.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/DhwaniInfoScreen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/FaqScreen.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/UserSubscription.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/assessment_screen.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';
import 'package:health_ed_flutter/modules/navigation/views/screens/MainScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final String pendingEvaluationImage = 'assets/images/pending.png';
  final String startEvaluationImage = 'assets/images/startassess.gif';
  final String assessmentCompletedGif = 'assets/images/startactivity.gif';

  final List<String> carouselImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  final List<String> carouselMessages = [
    "The Dhwani application cures delayed speech through extensive and rigorous practices.  The journey enables the child to catch up the lost time and excel further.  The learning cycle includes a proprietary algorithm which caters to different children with different stages of delayed speech and language. Whatever be the reason for delayed speech & language i.e whether it is because of Autism, ADD, ADHD etc. we got you covered.",
    "Does your child (Age between 1-5) speak normally, but still need to ACCELERATE the speaking power?\n\nYes, you are at the right place. Our Accelerated Speech program helps to accelerate the speaking power among children.  The curriculum helps to boost the speaking power and helps the child communicate further.",
    "Dear Parents,\n\nIn this journey we will walk hand in hand in improving the speaking power of the child. A long journey that will bear fruits which will give immense satisfaction to everyone. The Dhwani application is a tool which will act as a force multiplier in the life of a child. Regular practice, consistent effort and a disciplined approach will bring wonders to the child.\n\nThanks,\nThe Dhwani Team",
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Check if the device is a tablet
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    // Load user data
    var userData = LocalStorage.prefs.getString('userProfileData') != null
        ? jsonDecode(LocalStorage.prefs.getString('userProfileData')!)['user']
        : '';

    print(userData['subscriptionStatus']);

    // Determine onTapAction
    VoidCallback? onTapAction;

    if (userData['onboardingScore'] == 0) {
      onTapAction = () => Get.to(() => AssessmentScreen());
    } else if (userData['onboardingScore'] == 0 &&
        userData['assessmentPaymentStatus'] == 'paid') {
      if (userData['isTeacherEvaluationCompleted'] == false) {
        onTapAction = () {
          Get.snackbar(
            'Teacher Evaluation Pending',
            'A teacher will visit and evaluate your child soon. Please be patient.',
            backgroundColor: Colors.orange.shade100,
            colorText: Colors.black,
          );
        };
      } else {
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
      onTapAction = () {
        Get.to(() => AllQuizzesScreen());
      };
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bg/auth_bg.png'),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 16.0 : 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTransparentContainer(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: isTablet ? 30 : 20),

                          // Carousel Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: isTablet ? 20 : 10),
                            child: Column(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: isTablet ? 200 : 120,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentIndex = index;
                                      });
                                    },
                                  ),
                                  items: carouselImages
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final image = entry.value;

                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Message"),
                                            content: SingleChildScrollView(
                                              child:
                                                  Text(carouselMessages[index]),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text("Close"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(image,
                                            fit: BoxFit.fill),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: isTablet ? 15 : 10),
                                AnimatedSmoothIndicator(
                                  activeIndex: _currentIndex,
                                  count: carouselImages.length,
                                  effect: ExpandingDotsEffect(
                                    activeDotColor: Colors.black,
                                    dotColor: Colors.grey.shade300,
                                    dotHeight: isTablet ? 10 : 8,
                                    dotWidth: isTablet ? 10 : 8,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Assessment Card Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 10 : 2),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: onTapAction,
                                child: Container(
                                  width: double.infinity,
                                  height: isTablet ? 180 : 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: buildImage(userData),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isTablet ? 40 : 30),

                          // Grid Buttons Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 10 : 2),
                            child: GridView.count(
                              crossAxisCount: isTablet ? 3 : 2,
                              crossAxisSpacing: isTablet ? 12 : 8,
                              mainAxisSpacing: isTablet ? 12 : 8,
                              childAspectRatio: isTablet ? 1.2 : 1.5,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                _buildGridButton(
                                  'Contact Us',
                                  Icons.contact_page,
                                  [
                                    Color.fromARGB(255, 244, 0, 0),
                                    Color.fromARGB(255, 133, 46, 46)
                                  ],
                                  1,
                                  userData,
                                  isTablet,
                                ),
                                _buildGridButton(
                                    'Get Premium',
                                    Icons.emoji_events,
                                    [
                                      Color.fromARGB(255, 40, 3, 252),
                                      Color.fromARGB(255, 43, 61, 116)
                                    ],
                                    2,
                                    userData,
                                    isTablet),
                                _buildGridButton(
                                    'How to get best\nresults!',
                                    Icons.menu_book,
                                    [
                                      Color.fromARGB(255, 6, 253, 130),
                                      Color.fromARGB(255, 18, 72, 42)
                                    ],
                                    3,
                                    userData,
                                    isTablet),
                                if (!isTablet) // Only show FAQ in a separate box on mobile
                                  _buildGridButton(
                                      'FAQ',
                                      Icons.help,
                                      [
                                        Color.fromARGB(255, 255, 196, 1),
                                        Color.fromARGB(255, 91, 74, 21)
                                      ],
                                      4,
                                      userData,
                                      isTablet),
                                if (isTablet) // On tablet, add FAQ and one more button
                                  _buildGridButton(
                                      'FAQ',
                                      Icons.help,
                                      [
                                        Color.fromARGB(255, 255, 196, 1),
                                        Color.fromARGB(255, 91, 74, 21)
                                      ],
                                      4,
                                      userData,
                                      isTablet),
                              ],
                            ),
                          ),

                          SizedBox(height: isTablet ? 50 : 40),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(String title, IconData icon,
      List<Color> gradientColors, int gridNo, userData, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 4.0 : 2.0),
      child: InkWell(
        onTap: () {
          if (gridNo == 1) {
            Get.to(() => ContactScreen());
          } else if (gridNo == 2) {
            if (userData['subscriptionStatus'] == 'active') {
              Get.to(() => UserSubscription());
            } else {
              Get.to(() => AllPlanScreen());
            }
          } else if (gridNo == 3) {
            Get.to(() => DhwaniInfoScreen());
          } else if (gridNo == 4) {
            Get.to(() => FaqScreen());
          } else if (gridNo == 5) {
            // Action for additional tablet button
            Get.to(() => MainScreen());
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: isTablet ? 24 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: isTablet ? 40 : 30),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 18 : 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(Map<String, dynamic> userData) {
    print(json.encode(userData));
    final int onboardingScore = userData['onboardingScore'] ?? 0;
    final String paymentStatus =
        userData['assessmentPaymentStatus'] ?? 'unpaid';
    final bool isTeacherEvaluationCompleted =
        userData['isTeacherEvaluationCompleted'] ?? false;

    String imageToShow;

    if (onboardingScore == 0 && paymentStatus != 'paid') {
      imageToShow = startEvaluationImage;
    } else if (onboardingScore == 0 && paymentStatus == 'paid') {
      imageToShow = pendingEvaluationImage;
    } else {
      imageToShow = assessmentCompletedGif;
    }

    return Image.asset(
      imageToShow,
      fit: BoxFit.fill,
    );
  }
}
