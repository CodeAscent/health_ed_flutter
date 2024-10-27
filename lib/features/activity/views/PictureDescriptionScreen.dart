import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

import '../../../core/utils/custom_widgets.dart';

class PictureDescriptionScreen extends StatefulWidget {
  @override
  _PictureDescriptionScreenState createState() => _PictureDescriptionScreenState();
}

class _PictureDescriptionScreenState extends State<PictureDescriptionScreen> {
  String selectedLanguage = 'English';
  bool isDragging = false;

  // Track the matched shapes
  Map<String, bool> matchedShapes = {
    "Circle": false,
    "Star": false,
    "Triangle": false,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bg/videobgimage.png'),
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
                    AppBackButton(color:Colors.white),
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
                        'Watch Carefully',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
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
                    'assets/bg/imageActivity.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),

                // Vertically scrollable ListView
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Replace with the actual count of your items
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Image.asset(
                              'assets/icons/volume_up.png',
                              width: 30,
                            ),
                                SizedBox(width: 20), // Spacing between icon and text
                                Expanded(
                                  child: Text(
                                    'Spot no. of children $index', // Replace with actual text
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
