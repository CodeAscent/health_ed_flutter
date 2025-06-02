import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/utils/custom_loader.dart';
import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:health_ed_flutter/modules/auth/models/response/AllPlanResponse.dart';
import 'package:health_ed_flutter/modules/auth/repository/auth_repository.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/PaymentPage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AllPlanScreen extends StatelessWidget {
  const AllPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository())..add(PlanDataRequested()),
      child: AllPlanScreenContent(),
    );
  }
}

class AllPlanScreenContent extends StatefulWidget {
  const AllPlanScreenContent({Key? key}) : super(key: key);

  @override
  ActivityInstructionContent createState() => ActivityInstructionContent();
}

class ActivityInstructionContent extends State<AllPlanScreenContent> {
  List<PlanData> plans = [];
  bool screenloaded = false;

  int _currentIndex = 0;

  //  @override
  // void initState() {
  //   super.initState();
  //   // Trigger the event to fetch assessment questions
  //           print('initState123');
  //   context.read<AuthBloc>().add(PlanDataRequested());
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load user data
    var userData = LocalStorage.prefs.getString('userProfileData') != null
        ? jsonDecode(LocalStorage.prefs.getString('userProfileData')!)['user']
        : '';
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPlanFailure) {
          customSnackbar(state.message, ContentType.failure);
        }
      },
      builder: (context, state) {
        if ((state is AuthPlanSuccess)) {
          screenloaded = true;
          plans = state.allPlanResponse.data ?? [];

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        SizedBox(width: 8),
                        Text(
                          'All Plans',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),

                  // Plan Carousel
                  Expanded(
                    child: Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: plans.length,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.7,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final plan = plans[index];
                            return _buildPlanCard(plan, index, userData);
                          },
                        ),
                        SizedBox(height: 12),
                        AnimatedSmoothIndicator(
                          activeIndex: _currentIndex,
                          count: plans.length,
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
                ],
              ),
            ),
          );
        } else {
          return CustomLoader();
        }
      },
    );
  }

  Widget _buildPlanCard(PlanData plan, int index, userData) {
    final List<Color> bgColors = [
      Colors.teal.shade100,
      Colors.amber.shade100,
      Colors.purple.shade100,
      Colors.blue.shade100,
      Colors.orange.shade100,
      Colors.green.shade100,
      Colors.red.shade100,
    ];

    final Color bgColor = bgColors[index % bgColors.length];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  plan.name!,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${plan.price}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),

                          // Duration Badge
                          if (!plan.name!
                              .contains('Comprehensive Assessment Plan'))
                            Container(
                              margin: const EdgeInsets.only(top: 6, bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                plan.duration.toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),

                          // Description
                          Text(
                            plan.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),

                          SizedBox(height: 16),
                          Text(
                            'Features',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Features List
                          ...plan.features!.map<Widget>((feature) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 18, color: Colors.black87),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),

                  // CTA Button
                  if (!plan.name!.contains('Online Speech Therapy'))
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (userData['onboardingScore'] == 0 &&
                                !plan.name!.contains(
                                    'Comprehensive Assessment Plan')) {
                              Get.snackbar(
                                'Assessment Incomplete',
                                'Please complete the assessment to continue.',
                                backgroundColor: Colors.orange.shade100,
                                colorText: Colors.black,
                              );
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Refund Policy'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'The following pointers are applicable for the Users who are paying for any services:-\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '''
• There will be no refund for any of the subscription availed (Monthly or Annually)
• The refund for Comprehensive Assessment Plan will only be applicable if the assessment is not done and the report is not provided within 15 days of payment received
• The refund for online speech therapy will be provided for the unused sessions only after 15 days of the expired date of the sessions. The refund will be processed only after the communication is received from the users over mail to archanasthedhwani@gmail.com  (Ex- If for a month 16 sessions are scheduled from 1 May 2025 to 31 May 2025, only 12 are availed, the refund will be provided after 15 June 2025)
• A single promotional code can be used once and cannot be clubbed with any other offers
• Payments include all taxes.
• All payments to be done through Razorpay
• All disputes are subjected to Bhubaneswar jurisdiction only
• Cancellation of service can be done by writing to us at archanasthedhwani@gmail.com
                                      ''',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Get.to(PaymentPage(planData: plan));
                                    },
                                    child: Text('Agree'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 36, vertical: 12),
                          ),
                          child: Text('Choose Plan'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
