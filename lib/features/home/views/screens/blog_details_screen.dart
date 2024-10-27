import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

import '../../../../core/utils/custom_widgets.dart';

class BlogDetailsScreen extends StatefulWidget {
  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bg/profilebg.png'),
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
                        Row(
                          children: [
                            AppBackButton(color: Colors.white),
                            Text(
                              '10 min read',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Blog image
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage('assets/bg/imageActivity.png'), // Replace with your image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 16), // Spacing below the image

                        // Title
                        Text(
                          'Spot no. of children', // Replace with actual title
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8), // Spacing below title

                        // Scrollable description
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.'
                                    'This is the description of the blog. Here you can write a detailed explanation about the blog topic. You can include multiple lines of text to make it comprehensive and informative for the readers. The content should be engaging and provide value to the audience.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your action here if needed
          },
          child: Icon(Icons.waving_hand_sharp), // Waving hand icon
          backgroundColor: ColorPallete.primary, // Customize the background color
          tooltip: 'Wave Hand',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
