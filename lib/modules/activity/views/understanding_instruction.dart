import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/activity/views/MatchScreen.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/home/repository/home_repository.dart';
import 'package:health_ed_flutter/modules/activity/views/understanding_screen.dart';

class UnderstandingInstruction extends StatefulWidget {
  final ResAllQuestion resAllQuestion;
  const UnderstandingInstruction({super.key, required this.resAllQuestion});

  @override
  State<UnderstandingInstruction> createState() =>
      _UnderstandingInstructionState();
}

class _UnderstandingInstructionState extends State<UnderstandingInstruction> {
  String selectedLanguage = 'English';
  String languageCode = 'en';
  final _tts = TextToSpeech();
  String selectedAcknowledgement = 'Acknowledgement';
  int score = 0;
  void navigateIfNotAvailable() {
    if (widget.resAllQuestion.data!.activity!.understandings!.learnings!
                .isEmpty &&
        widget.resAllQuestion.data!.activity!.understandings!.instruction ==
            null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() => MatchScreen(
              resAllQuestion: widget.resAllQuestion,
              showInstruction: true,
            ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    navigateIfNotAvailable();
  }

  @override
  Widget build(BuildContext context) {
    final understanding = widget.resAllQuestion.data!.activity!.understandings!;
    String titleData = understanding.instruction!.title![languageCode]!;
    String bodyData = understanding.instruction!.body![languageCode]!;
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
                          AppBackButton(),
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
                                        fontSize: 12, color: Colors.black),
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
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _tts.speak(titleData + bodyData,
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
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          HtmlWidget(
                            titleData,
                            textStyle: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          HtmlWidget(
                            bodyData,
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                      // Second Row: Speaker Icon and "Tiger" text
                      // MediaSlider()
                      // _buildSlider()
                      _buildAcknowledgementButton(context)
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

  bool isCompleted = false;
  Widget _buildAcknowledgementButton(BuildContext context) {
    final understanding = widget.resAllQuestion.data!.activity!.understandings!;

    return AcknowledgmentService.buildAcknowledgmentButton(
      context: context,
      selectedAcknowledgement: selectedAcknowledgement,
      secondaryColor: ColorPallete.secondary,
      onNext: () {
        Get.to(() => UnderstandingScreen(
              resAllQuestion: widget.resAllQuestion,
            ));
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
                  acknowledgement: selectedAcknowledgement,
                  learningInstruction: understanding.instruction!.sId!,
                  score: score,
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
                languageCode = 'hi';
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
                languageCode = 'or';
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

  void _showAcknowledgeDropdown(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Acknowledge Child\'s Understanding'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Not Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Not Understood';
                score = 0;
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Partially Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Partially Understood';
                score = 1;
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Understood';
                score = 2;
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Well Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Well Understood';
                score = 3;
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Fully Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Fully Understood';
                score = 4;
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
