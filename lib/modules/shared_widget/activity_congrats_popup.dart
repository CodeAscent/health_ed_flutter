import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/services/globals.dart';
import 'package:health_ed_flutter/models/completed_activity.dart';
import 'package:health_ed_flutter/modules/auth/models/response/OtpVerifyResponse.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_activity_screen.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';
import 'package:health_ed_flutter/modules/home/widgets/QuizItem.dart';
import 'package:health_ed_flutter/modules/profile%20/bloc/profile_cubit.dart';
import 'package:health_ed_flutter/viewmodels/complete_activity_viewmodel.dart';
import 'package:logger/logger.dart';

class ActivityCongratsPopup extends StatefulWidget {
  final String activityId;

  ActivityCongratsPopup({
    required this.activityId,
  });

  @override
  State<ActivityCongratsPopup> createState() => _ActivityCongratsPopupState();
}

class _ActivityCongratsPopupState extends State<ActivityCongratsPopup> {
  final CompleteActivityViewModel _completeActivityViewModel =
      CompleteActivityViewModel();
  @override
  void initState() {
    super.initState();
    markCompletedActivity();
  }

  markCompletedActivity() async {
    final userData = LocalStorage.prefs.getString('userData');

    _completeActivityViewModel.createCompletedActivity(CompletedActivity(
      activity: widget.activityId,
      user: jsonDecode(userData!)['user']['_id'],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Image.asset('assets/images/medal.png',
                      width: 100, height: 100),
                  SizedBox(height: 20),
                  Text(
                    'Congratulations!',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You have completed the activity',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 10),
                  // Text(
                  //   '10/10',
                  //   style: TextStyle(fontSize: 32, color: Colors.green, fontWeight: FontWeight.bold),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Displaying the custom confetti GIF
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/confetti.gif', // Path to your confetti GIF
              width: double.infinity, // Set desired width
              height: 300, // Set desired height
              fit: BoxFit.cover, // Adjust the fit as necessary
            ),
          ),
          // Positioned cross button at the top-right corner
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                if (selectedDayName != null) {
                  context
                      .read<HomeBloc>()
                      .add(GetAllActivityRequested(activityId: selectedDayId!));
                  Get.back();
                  // Get.off(() => AllActivityScreen(
                  //       dayName: selectedDayName!,
                  //       activityId: selectedDayId!,
                  //     ));
                } else {
                  Get.off(() => AllQuizzesScreen());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
