import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/features/home/views/screens/activity_video_understanding_screen.dart';
import 'package:html/parser.dart';
import '../../../../core/tts/text_to_speech.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../../../core/utils/helper.dart';
import '../../../activity/views/DragDropScreen.dart';
import '../../../activity/views/LearingVideoDescriptionScreen.dart';
import '../../../activity/views/MatchScreen.dart';
import '../../../activity/views/PictureDescriptionScreen.dart';
import '../../../activity/views/PictureSequencings.dart';
import '../../../activity/views/RevealPictureDescriptionScreen.dart';
import '../../../activity/views/VideoDescriptionScreen.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../../repository/home_repository.dart';

class ActivityInstructionsScreen extends StatelessWidget {
  final String activityId;

  const ActivityInstructionsScreen({Key? key, required this.activityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (_) => HomeBloc(HomeRepository())
      ..add(GetAllQuestionRequested(activityId: activityId)),
    child: ActivityVideoUnderstandingScreenContent(activityId: activityId,),
    );
  }
}


class ActivityVideoUnderstandingScreenContent extends StatefulWidget {
  final String activityId;

  const ActivityVideoUnderstandingScreenContent({Key? key, required this.activityId}) : super(key: key);

  @override
  ActivityInstructionContent createState() => ActivityInstructionContent();
}




class ActivityInstructionContent
    extends State<ActivityVideoUnderstandingScreenContent> {
  String languageCode = "en-US";
  String selectedLanguage = 'English';
  final TextToSpeech _tts = TextToSpeech();
  @override
  void dispose() {
    _tts.stop();  // Stop TTS when the screen is closed
    super.dispose();
  }

  @override
  void deactivate() {
    _tts.stop();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
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
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state is ActivityQuestionLoading) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is GetAllQuestionSuccess) {
                                String instructionHtml;
                                switch (getLanguageCode(selectedLanguage, languageCode)) {
                                  case 'hi':
                                    instructionHtml = state.resAllQuestion.data!.activity!.activityInstructions!.hi ?? "Instructions not available";
                                    break;
                                  case 'or':
                                    instructionHtml = state.resAllQuestion.data!.activity!.activityInstructions!.or ?? "Instructions not available";
                                    break;
                                  default:
                                    instructionHtml = state.resAllQuestion.data!.activity!.activityInstructions!.en ?? "Instructions not available";
                                }

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          AppBackButton(),
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
                                          _buildLanguageDropdown(context),
                                          SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              _tts.speak(parse(instructionHtml).documentElement!.text, languageCode: languageCode);
                                            },
                                            child: Image.asset(
                                              'assets/icons/volume_up1.png',
                                              width: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Make the HTML content scrollable
                                      SingleChildScrollView(
                                        child: HtmlWidget(
                                          instructionHtml,
                                          textStyle: TextStyle(fontSize: 14, color: ColorPallete.greyColor),
                                        ),
                                      ),
                                      SizedBox(height: 20), // Space before the button
                                    ],
                                  ),
                                );
                              } else if (state is GetAllQuestionFailure) {
                                return Center(child: Text(state.message));
                              }
                              return CustomLoader();
                            },
                          ),
                        ),
                        // Spacer to push the button to the bottom
                        Spacer(),
                        BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state is GetAllQuestionSuccess) {

                              return CustomGradientButton(
                                label: 'Done',
                                onTap: () {
                                  _tts.stop();
                                  if(state.resAllQuestion!.data!.activity!.understandings!.learnings!.length>0)
                                    {
                                      Get.off(() => ActivityVideoUnderstandingScreen(resAllQuestion: state.resAllQuestion));
                                    }else if(state.resAllQuestion.data!.activity!.matchings!.learnings!.length>0){
                                    Get.off(() => MatchScreen(resAllQuestion: state.resAllQuestion,));
                                  }else if(state.resAllQuestion.data!.activity!.pictureSequencings!.learnings!.length>0){
                                    Get.off(() => PictureSequencingsScreen(resAllQuestion: state.resAllQuestion,));
                                  }else if(state.resAllQuestion.data!.activity!.pictureUnderstandings!.learnings!.length>0){
                                    Get.off(() => PictureDescriptionScreen(resAllQuestion: state.resAllQuestion));
                                  }else if(state.resAllQuestion.data!.activity!.pictureExpressions!.learnings!.length>0){
                                    Get.off(() => LearingVideoDescriptionScreen(resAllQuestion: state.resAllQuestion,));
                                  }else if(state.resAllQuestion.data!.activity!.pictureExpressions!.learnings!.length>0){
                                    Get.off(() => VideoDescriptionScreen(resAllQuestion: state.resAllQuestion,));
                                  }else if(state.resAllQuestion.data!.activity!.pictureExpressions!.learnings!.length>0){
                                    Get.off(() => DragDropScreen(resAllQuestion: state.resAllQuestion,));
                                  }
                                },
                              );
                            }
                            return SizedBox();
                          },
                        ),
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
          _buildLanguageOption('Hindi'),
          _buildLanguageOption('English'),
          _buildLanguageOption('Odia'),
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

  CupertinoActionSheetAction _buildLanguageOption(String language) {
    return CupertinoActionSheetAction(
      child: Text(language),
      onPressed: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }


}
