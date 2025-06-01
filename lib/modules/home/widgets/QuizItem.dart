import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/services/globals.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/auth/views/screens/AllPlanScreen.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/repository/home_repository.dart';

import '../views/screens/all_activity_screen.dart';

class QuizItem extends StatelessWidget {
  final double prevDayProgress;
  final int dayIndex;
  final String day;
  final double progress;
  final String dayId;
  final bool isLocked;
  final BuildContext mContext;

  const QuizItem({
    Key? key,
    required this.prevDayProgress,
    required this.day,
    required this.progress,
    required this.dayId,
    required this.isLocked,
    required this.mContext,
    required this.dayIndex,
  }) : super(key: key);

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Locked'),
          content: Text(
              'This day is locked. Please upgrade your plan to access it.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => AllPlanScreen())?.then((_) {
                  mContext.read<HomeBloc>().add(GetAllDayRequested());
                });
              },
              child: Text('Upgrade'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            if (isLocked) {
              _showLockedDialog(
                  context); // Show modal instead of direct navigation
            } else if (prevDayProgress < 100) {
              Get.snackbar(
                'Locked',
                'Please complete the previous day to access this day.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white,
              );
            } else {
              selectedDayName = day;
              selectedDayId = dayId;
              Get.to(() => AllActivityScreen(
                    activityId: dayId,
                    dayName: day,
                  ));
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: ColorPallete.greyShade,
                  borderRadius: BorderRadius.circular(15),
                  image: !isLocked
                      ? DecorationImage(
                          image: AssetImage('assets/bg/qizzesbg.png'),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.46),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 8),
                    if (!isLocked)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          color: ColorPallete.greenShade,
                          backgroundColor: Colors.grey.shade100,
                          minHeight: 8,
                        ),
                      ),
                  ],
                ),
              ),
              if (isLocked)
                Positioned(
                  right: -1,
                  top: -5,
                  child: Image.asset(
                    'assets/icons/lock.png',
                    width: 20,
                    height: 20,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
