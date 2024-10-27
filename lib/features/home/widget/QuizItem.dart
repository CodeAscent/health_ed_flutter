import 'package:flutter/material.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

class QuizItem extends StatelessWidget {
  final String day;
  final bool completed;
  final bool isLocked;

  const QuizItem({
    Key? key,
    required this.day,
    required this.completed,
    required this.isLocked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              width: constraints.maxWidth, // Make container adapt to parent constraints
              decoration: BoxDecoration(
                color: ColorPallete.greyShade,
                borderRadius: BorderRadius.circular(15),
                image: !isLocked
                    ? DecorationImage(
                  image: AssetImage('assets/bg/qizzesbg.png'), // Replace with the path to your background image
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
                      color: Colors.black.withOpacity(0.46), // 46% opacity
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
                        value: 1.0,
                        color: ColorPallete.greenShade,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        minHeight: 8,
                        // Make progress indicator width match container
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
        );
      },
    );
  }
}
