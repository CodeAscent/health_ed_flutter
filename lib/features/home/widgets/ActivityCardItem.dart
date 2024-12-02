import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_ed_flutter/features/home/model/Activity.dart';
import 'package:health_ed_flutter/features/home/model/response/ResAllActivity.dart';

class ActivityCardItem extends StatelessWidget {
 final Activities activity;

  const ActivityCardItem({required this.activity});

  Color getStatusColor() {
    switch (activity.status) {
      case 'completed':
        return Colors.green;
      case 'Started':
        return Colors.red;
      case 'Pending':
      default:
        return Colors.white;
    }
  }
  String getStatusEmoji() {
    switch (activity.status) {
      case 'completed':
        return '😇';
      case 'Started':
        return '😕';
      case 'Pending':
      default:
        return 'Start 👉🏼';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getStatusColor(),
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical:activity.status == 'Pending' ? 25:1,horizontal: 20), // Adds padding for more spacing
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              activity.activityName!.hi!,
              style: TextStyle(
                color: activity.status == 'Pending' ? Colors.black : Colors.white,
                fontSize: 16, // Adjust font size as needed
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                getStatusEmoji(),
                style: TextStyle(
                  fontSize: activity.status == 'Pending' ? 16 : 50, // Smaller size if 'Start' is shown
                  color: activity.status == 'Pending' ? Colors.green : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
