import 'package:flutter/material.dart';

class ActivityCongratsPopup extends StatelessWidget {
  final String level;

  ActivityCongratsPopup({required this.level});

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
                Image.asset('assets/images/medal.png', width: 100, height: 100),
                SizedBox(height: 20),
                Text(
                  'Congratulations!',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'You have scored',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  '10/10',
                  style: TextStyle(fontSize: 32, color: Colors.green, fontWeight: FontWeight.bold),
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
        // Positioned cross button at the top-right corner
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.of(context).pop(); // Close the popup
            },
          ),
        ),
      ],
    );
  }
}
