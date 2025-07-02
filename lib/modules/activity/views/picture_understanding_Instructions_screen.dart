import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/services/globals.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';
import 'package:html/parser.dart';
import '../../../core/tts/text_to_speech.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../../core/utils/helper.dart';
import 'PictureUnderstandingScreen.dart';

class PictureUnderstandingInstructionsScreen extends StatefulWidget {
  final ResAllQuestion resAllQuestion;
  final bool showInstruction;
  const PictureUnderstandingInstructionsScreen(
      {Key? key, required this.resAllQuestion, required this.showInstruction})
      : super(key: key);
  @override
  _PictureUnderstandingScreenState createState() =>
      _PictureUnderstandingScreenState();
}

class _PictureUnderstandingScreenState
    extends State<PictureUnderstandingInstructionsScreen> {
  String languageCode1 = "en";
  String selectedLanguage = 'English';
  late Instruction instruction;

  final TextToSpeech _tts = TextToSpeech();
  @override
  void dispose() {
    _tts.stop(); // Stop TTS when the screen is closed
    super.dispose();
  }

  @override
  void deactivate() {
    _tts.stop();
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    // navigateIfNotAvailable();

    instruction = widget
        .resAllQuestion.data!.activity!.pictureUnderstandings!.instruction!;
  }

  @override
  Widget build(BuildContext context) {
    String titleData = instruction.title![languageCode1]!;
    String bodyData = instruction.body![languageCode1]!;

    return SafeArea(
      child: Scaffold(
        body: Container(
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
                      SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppBackButton(
                                  onTap: () async {
                                    final shouldExit = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            'Are you sure you want to exit the activity?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false), // Cancel
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (selectedDayName != null) {
                                                context.read<HomeBloc>().add(
                                                    GetAllActivityRequested(
                                                        activityId:
                                                            selectedDayId!));
                                                Get.back();
                                              } else {
                                                Get.off(
                                                    () => AllQuizzesScreen());
                                              }
                                              Navigator.of(context).pop(true);
                                            }, // Confirm
                                            child: Text('Confirm'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldExit == true) {
                                      Navigator.of(context)
                                          .pop(); // Exit the activity
                                    }
                                  },
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Instructions',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                // _buildLanguageDropdown(context),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    _tts.speak(
                                      parse(bodyData).documentElement!.text,
                                      languageCode: getLanguageCode(
                                          selectedLanguage, languageCode1),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/icons/volume_up1.png',
                                    width: 40,
                                  ),
                                ),
                              ],
                            ),
                            // Make the HTML content scrollable
                            Expanded(
                              child: SingleChildScrollView(
                                child: HtmlWidget(
                                  bodyData,
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: ColorPallete.greyColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20), // Space before the button
                          ],
                        ),
                      ),
                      // Spacer to push the button to the bottom
                      Spacer(),
                      CustomGradientButton(
                        label: 'Done',
                        onTap: () {
                          _tts.stop();
                          Get.to(() => PictureUnderstandingScreen(
                                resAllQuestion: widget.resAllQuestion,
                                showInstruction: false,
                              ));
                        },
                      )
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

  Widget _buildLanguageDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCupertinoDropdown(context),
      child: Container(
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
        child: Row(
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
    );
  }

  void _showCupertinoDropdown(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Select Language'),
        actions: <Widget>[
          _buildLanguageOption('Hindi', 'hi'),
          _buildLanguageOption('English', 'en'),
          _buildLanguageOption('Odia', 'or'),
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

  CupertinoActionSheetAction _buildLanguageOption(
      String language, String languagecode) {
    return CupertinoActionSheetAction(
      child: Text(language),
      onPressed: () {
        setState(() {
          selectedLanguage = language;
          languageCode1 = languagecode;
        });
        Navigator.pop(context);
      },
    );
  }
}
