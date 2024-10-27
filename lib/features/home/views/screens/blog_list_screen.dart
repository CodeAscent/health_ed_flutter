import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/custom_widgets.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
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
                    CustomTransparentContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Blogs',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
              Expanded(
                child:
                ListView.builder(
                  itemCount: 10, // Replace with the actual count of your items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                      Row(
                        children: [
                          Container(
                            width: 104,
                            height: 77,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                              image: DecorationImage(
                                image: AssetImage('assets/bg/imageActivity.png'), // Replace with your image
                                fit: BoxFit.cover, // Optional: fit the image inside the rounded container
                              ),
                            ),
                          ),
                          SizedBox(width: 20), // Spacing between icon and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Modified Text widget
                                Text(
                                  'Spot no. of children Spot no. of children  Spot no. of children  Spot no. of children  Spot no. of children  Spot no. of children  Spot no. of children  $index', // Replace with actual title
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2, // Limit to 2 lines
                                  overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                ),
                                SizedBox(height: 4), // Spacing between title and hand clap
                                Row(
                                  children: [
                                    Icon(Icons.waving_hand_sharp, color: Colors.grey, size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      '32.4k', // Replace with actual text for hand clap
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ), // Spacing below hand clap row
                                Text(
                                  '10 min read', // Duration text
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )),
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
