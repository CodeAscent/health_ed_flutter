import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/ActivityInstructionsCubit.dart';

class ActivityInstructionsScreen extends StatefulWidget {
  @override
  _ActivityInstructionsScreenState createState() => _ActivityInstructionsScreenState();
}

class _ActivityInstructionsScreenState extends State<ActivityInstructionsScreen> {
  String selectedLanguage = 'English'; // Default language

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityInstructionsCubit(),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bg/auth_bg.png'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTransparentContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppBackButton(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Activity Instructions',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6), // Background color
                              borderRadius: BorderRadius.circular(5), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Shadow color
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () => _showCupertinoDropdown(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedLanguage,
                                    style: TextStyle(fontSize: 12, color: Colors.black),
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
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              // Add sound play functionality here
                            },
                            child: Image.asset(
                              'assets/icons/volume_up1.png',
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Get ready for an exciting challenge! In this activity, you’ll have fun while learning something new...",
                                style: TextStyle(fontSize: 14, color: ColorPallete.greyColor),
                              ),
                              SizedBox(height: 8),
                              buildStep("Step 1: Understand the Task", "Read each question or prompt carefully...", context),
                              buildStep("Step 2: Complete the Activity", "Use the provided tools—whether it’s dragging items...", context),
                              buildStep("Step 3: Submit Your Answer", "When you’re done, click the Submit button to move on...", context),
                              buildStep("Step 4: Track Your Progress", "Once you’re finished, you’ll see how well you did...", context),
                            ],
                          ),
                        ),
                      ),
                      CustomGradientButton(
                        label: 'Done',
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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

  Widget buildStep(String title, String description, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: ColorPallete.greyColor),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

