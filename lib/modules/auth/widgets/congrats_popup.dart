import 'package:flutter/material.dart';

class CongratsPopup extends StatelessWidget {
  final String level;

  CongratsPopup({required this.level});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                Image.asset('assets/images/menrunning.png', width: 100, height: 100),
                SizedBox(height: 20),
                Text(
                  'Congratulations!',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'LEVEL $level',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
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
      ],
    );
  }
}
