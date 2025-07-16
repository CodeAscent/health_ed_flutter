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
  final bool canOpen;
  final BuildContext mContext;

  const QuizItem({
    Key? key,
    required this.prevDayProgress,
    required this.day,
    required this.progress,
    required this.dayId,
    required this.isLocked,
    required this.canOpen,
    required this.mContext,
    required this.dayIndex,
  }) : super(key: key);

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple.shade50, Colors.blue.shade50],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 60, color: Colors.deepPurple),
                SizedBox(height: 16),
                Text('Premium Content Locked',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    )),
                SizedBox(height: 16),
                Text(
                  'Upgrade your plan to unlock this exclusive content and access all premium features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Later',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.deepPurple,
                        shadowColor: Colors.deepPurple.withOpacity(0.3),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(() => AllPlanScreen())?.then((_) {
                          mContext.read<HomeBloc>().add(GetAllDayRequested());
                        });
                      },
                      child: Text('Upgrade Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNextDayUnlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 10,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple.shade50, Colors.blue.shade50],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(Icons.lock_clock_rounded,
                        size: 50, color: Colors.deepPurple),
                  ],
                ),
                SizedBox(height: 20),
                Text('Content Locked',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    )),
                SizedBox(height: 12),
                Text(
                  'This day will be automatically unlocked tomorrow. '
                  'Check back then to continue your journey!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 24),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.deepPurple,
                    shadowColor: Colors.deepPurple.withOpacity(0.3),
                    elevation: 5,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Understood',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                ),
              ],
            ),
          ),
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
            } else if (!canOpen) {
              _showNextDayUnlockDialog(context);
            } else {
              selectedDayName = day;
              selectedDayId = dayId;

              Get.to(() => AllActivityScreen(
                    activityId: dayId,
                    dayName: day,
                  ))?.then((_) {
                mContext.read<HomeBloc>().add(GetAllDayRequested());
              });
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
