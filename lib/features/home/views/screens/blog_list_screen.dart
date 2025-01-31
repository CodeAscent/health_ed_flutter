import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/features/home/views/screens/blog_details_screen.dart';

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
                    return  GestureDetector(
                        onTap: () {
                      // Navigate to your target screen, e.g., DetailScreen
                      Get.to(() => BlogDetailsScreen()); // Pass any data if needed
                    },
                    child:
                      Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                      Row(
                        children: [
                          Container(
                            width: 104,
                            height: 77,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage('assets/bg/imageActivity.png'),
                                fit: BoxFit.cover,
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
                    ));
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


}
