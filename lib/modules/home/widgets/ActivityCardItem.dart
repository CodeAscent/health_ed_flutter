import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health_ed_flutter/modules/home/model/Activity.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllActivity.dart';

class ActivityCardItem extends StatelessWidget {
  final Activities activity;

  const ActivityCardItem({required this.activity});

  Color getStatusColor() {
    switch (activity.status) {
      case 'COMPLETED':
        return Colors.green;
      case 'IN-PROGRESS':
        return Colors.orange;
      case 'NOT_STARTED':
      default:
        return Colors.white;
    }
  }

  String getTextStatus() {
    switch (activity.status) {
      case 'COMPLETED':
        return 'COMPLETED';
      case 'IN-PROGRESS':
        return 'IN-PROGRESS';
      case 'NOT_STARTED':
      default:
        return 'NOT_STARTED';
    }
  }

  String getStatusEmoji() {
    switch (activity.status) {
      case 'COMPLETED':
        return '😇';
      case 'IN-PROGRESS':
        return '😕';
      case 'NOT_STARTED':
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
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                activity.activityName!.en!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: getTextStatus() == 'NOT_STARTED'
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  getStatusEmoji(),
                  style: TextStyle(
                    fontSize: activity.status == 'NOT_STARTED' ? 50 : 16,
                    color:
                        getTextStatus() == 'NOT_STARTED' ? Colors.green : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
