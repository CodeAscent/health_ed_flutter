import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/core/services/globals.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/activity/views/MatchScreen.dart';
import 'package:health_ed_flutter/modules/activity/views/understanding_instruction.dart';
import 'package:health_ed_flutter/modules/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResUserAcknowledgement.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_activity_screen.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';
import 'package:logger/logger.dart';

import '../../../core/tts/text_to_speech.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../../core/utils/helper.dart';
import '../widgets/MediaSlider.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';
import '../../home/bloc/home_state.dart';
import '../../home/model/response/ResAllQuestion.dart';

class UnderstandingScreen extends StatefulWidget {
  final ResAllQuestion resAllQuestion;

  UnderstandingScreen({required this.resAllQuestion});

  @override
  _ActivityUnderstandingScreenContentState createState() =>
      _ActivityUnderstandingScreenContentState();
}

class _ActivityUnderstandingScreenContentState
    extends State<UnderstandingScreen> {
  String languageCode = "en-US";
  String selectedLanguage = 'English';
  String selectedAcknowledgement = 'Acknowledgement';
  int currentIndex = 0;
  final TextToSpeech _tts = TextToSpeech();
  late Learnings learnings;
  bool isDragging = false;
  Map<String, bool> matchedShapes = {
    "Circle": false,
    "Star": false,
    "Triangle": false,
  };

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    learnings = widget.resAllQuestion.data!.activity!.understandings!
        .learnings![currentIndex];
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetSubmitAcknowledgeResponseFailure) {
          customSnackbar(state.message, ContentType.failure);
        }
      },
      builder: (context, state) {
        String titleData;
        switch (getLanguageCode(selectedLanguage, languageCode)) {
          case 'hi':
            titleData = learnings.title!.hi ?? "Instructions not available";
            break;
          case 'or':
            titleData = learnings.title!.or ?? "Instructions not available";
            break;
          default:
            titleData = learnings.title!.en ?? "Instructions not available";
        }
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              Navigator.of(context).pop(false),
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            context.read<HomeBloc>().add(
                                                GetAllActivityRequested(
                                                    activityId:
                                                        selectedDayId!));
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
                              // Container(
                              //   padding: EdgeInsets.all(8),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white.withOpacity(0.6),
                              //     borderRadius: BorderRadius.circular(5),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.black.withOpacity(0.1),
                              //         spreadRadius: 1,
                              //         blurRadius: 1,
                              //         offset: Offset(0, 2),
                              //       ),
                              //     ],
                              //   ),
                              //   child: GestureDetector(
                              //     onTap: () => _showCupertinoDropdown(context),
                              //     child: Row(
                              //       children: [
                              //         Text(
                              //           selectedLanguage,
                              //           style: TextStyle(
                              //               fontSize: 12, color: Colors.black),
                              //         ),
                              //         Icon(
                              //           CupertinoIcons.chevron_down,
                              //           color: Colors.black,
                              //           size: 14,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _tts.speak(titleData,
                                          languageCode: languageCode);
                                    },
                                    child: Image.asset(
                                      'assets/icons/volume_up1.png',
                                      width: 40,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      titleData,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              MediaSlider(
                                key: ValueKey(learnings.sId),
                                mediaList: learnings.media!,
                              ),
                              Spacer(),
                              _buildAcknowledgementButton(context),
                            ],
                          )),
                          // Second Row: Speaker Icon and "Tiger" text
                          // MediaSlider()
                          // _buildSlider()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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

  int score = 0;
  bool isCompleted = false;
  // Replace the existing acknowledgment code with:

  Widget _buildAcknowledgementButton(BuildContext context) {
    bool isCompleted = widget
            .resAllQuestion.data!.activity!.understandings!.learnings!.length ==
        currentIndex + 1;

    return AcknowledgmentService.buildAcknowledgmentButton(
      context: context,
      selectedAcknowledgement: selectedAcknowledgement,
      secondaryColor: ColorPallete.secondary,
      onNext: () {
        if (isCompleted) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (_) => UnderstandingInstruction(
                key: ValueKey('activity_1'),
                resAllQuestion: widget.resAllQuestion,
                activityNo: 1,
              ),
            ),
          );

          // Get.to(() => MatchScreen(
          //       resAllQuestion: widget.resAllQuestion,
          //       showInstruction: true,
          //     ));
        } else {
          setState(() {
            currentIndex++;
            selectedAcknowledgement = 'Acknowledgement';
            learnings = widget.resAllQuestion.data!.activity!.understandings!
                .learnings![currentIndex];
          });
        }
      },
      onAcknowledge: (acknowledgement, score) async {
        setState(() {
          selectedAcknowledgement = acknowledgement;
          this.score = score;
        });

        context.read<HomeBloc>().add(
              SubmitAcknowledgementRequest(
                acknowledgementRequest: AcknowledgementRequest(
                  activity: widget.resAllQuestion.data!.activity!.sId!,
                  acknowledgement: acknowledgement,
                  learning: learnings.sId!,
                  score: score,
                ),
              ),
            );
      },
    );
  }
}
