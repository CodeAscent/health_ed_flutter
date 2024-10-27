import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_ed_flutter/features/home/model/Activity.dart';

class ActivityCardItem extends StatelessWidget {
  final Activity activity;

  const ActivityCardItem({required this.activity});

  Color getStatusColor() {
    switch (activity.status) {
      case 'completed':
        return Colors.green;
      case 'incomplete':
        return Colors.red;
      case 'not_started':
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getStatusColor(),
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical:activity.status == 'not_started' ? 25:1,horizontal: 20), // Adds padding for more spacing
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              activity.name,
              style: TextStyle(
                color: activity.status == 'not_started' ? Colors.black : Colors.white,
                fontSize: 16, // Adjust font size as needed
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                activity.status == 'not_started' ? "Start ${activity.emoji}" : activity.emoji,
                style: TextStyle(
                  fontSize: activity.status == 'not_started' ? 16 : 50, // Smaller size if 'Start' is shown
                  color: activity.status == 'not_started' ? Colors.green : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
