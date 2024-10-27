import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

import '../../../core/utils/custom_widgets.dart';

class VideoDescriptionScreen extends StatefulWidget {
  @override
  _VideoDescriptionScreenState createState() =>
      _VideoDescriptionScreenState();
}

class _VideoDescriptionScreenState extends State<VideoDescriptionScreen> {
  String selectedLanguage = 'English';
  bool isDragging = false;

  // Track the matched shapes and selection state
  Map<String, bool> matchedShapes = {
    "Circle": false,
    "Star": false,
    "Triangle": false,
  };

  // Track selected card
  List<bool> selectedCards = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bg/videobg.png'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBackButton(color: Colors.white),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () => _showCupertinoDropdown(context),
                        child: Row(
                          children: [
                            Text(
                              selectedLanguage,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: Colors.black,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add sound play functionality here
                      },
                      child: Image.asset(
                        'assets/icons/volume_up.png',
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Watch this video before answering questions',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Image with full width and fixed height
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width,
                  height: 227,
                  child: Image.asset(
                    'assets/bg/videoactivity.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add sound play functionality here
                      },
                      child: Image.asset(
                        'assets/icons/volume_up.png',
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Which animal was in this video?',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Grid with options
                SizedBox(
                  height: 200,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    children: [
                      _buildOptionCard("Lion", 0),
                      _buildOptionCard("Elephant", 1),
                      _buildOptionCard("Tiger", 2),
                      _buildOptionCard("Giraffe", 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection state
          selectedCards[index] = !selectedCards[index];
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: selectedCards[index] ? Colors.green : Colors.white.withOpacity(0.9),
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (selectedCards[index])
              Positioned(
                right: 4,
                top: 3,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCupertinoDropdown(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Select Language'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Hindi'),
            onPressed: () {
              setState(() {
                selectedLanguage = 'Hindi';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('English'),
            onPressed: () {
              setState(() {
                selectedLanguage = 'English';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Odia'),
            onPressed: () {
              setState(() {
                selectedLanguage = 'Odia';
              });
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
