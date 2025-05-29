import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/modules/activity/views/MatchScreen.dart';
import 'package:health_ed_flutter/modules/activity/views/PictureSequencings.dart';
import 'package:health_ed_flutter/modules/activity/views/PictureUnderstandingScreen.dart';
import 'package:health_ed_flutter/modules/activity/views/pictureExpression.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/activity/views/understanding_screen.dart';
import 'package:health_ed_flutter/modules/shared_widget/activity_congrats_popup.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class UnderstandingInstruction extends StatefulWidget {
  final ResAllQuestion resAllQuestion;
  final int activityNo;

  const UnderstandingInstruction(
      {super.key, required this.resAllQuestion, required this.activityNo});

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
  bool isLastScreen = false;
  bool isCompleted = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100));
      _navigateToFirstValidActivity();
    });
  }

  String htmlToPlainText(String htmlString) {
    dom.Document document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  void _navigateToFirstValidActivity() {
    final data = widget.resAllQuestion.data!.activity!;
    final currentNo = widget.activityNo;

    final instructionList = [
      data.understandings?.instruction,
      data.matchings?.instruction,
      data.pictureUnderstandings?.instruction,
      data.pictureExpressions?.instruction,
      data.pictureSequencings?.instruction,
    ];

    final learningList = [
      data.understandings?.learnings,
      data.matchings?.learnings,
      data.pictureUnderstandings?.learnings,
      data.pictureExpressions?.learnings,
      data.pictureSequencings?.learnings,
    ];

    int? nextValidActivity;

    for (int i = currentNo; i < instructionList.length; i++) {
      print(learningList[i]!.isNotEmpty);
      if (instructionList[i] != null && learningList[i]!.isNotEmpty) {
        nextValidActivity = i;
        break;
      }
    }

    if (nextValidActivity != null && nextValidActivity != currentNo) {
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
          builder: (_) => UnderstandingInstruction(
            key: ValueKey('activity_$nextValidActivity'),
            resAllQuestion: widget.resAllQuestion,
            activityNo: nextValidActivity!,
          ),
        ),
      );
    } else if (nextValidActivity == null) {
      setState(() {
        isLastScreen = true;
      });

      // Get.dialog(
      //   ActivityCongratsPopup(
      //     activityId: widget.resAllQuestion.data!.activity!.sId!,
      //   ),
      //   barrierDismissible: false,
      // );
      // print('No instruction available for any remaining activity');
      // showDialog(
      //   context: context,
      //   builder: (context) => CustomDialog(
      //     title: 'No Activity',
      //     message: 'No activity available',
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLastScreen) {
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.6),
        body: Center(
          child: ActivityCongratsPopup(
            activityId: widget.resAllQuestion.data!.activity!.sId!,
          ),
        ),
      );
    }

    final data = widget.resAllQuestion.data!.activity!;
    final no = widget.activityNo;

    final instruction = switch (no) {
      0 => data.understandings?.instruction,
      1 => data.matchings?.instruction,
      2 => data.pictureUnderstandings?.instruction,
      3 => data.pictureExpressions?.instruction,
      4 => data.pictureSequencings?.instruction,
      _ => null,
    };

    String titleData = instruction?.title?[languageCode] ?? '';
    String bodyData = instruction?.body?[languageCode] ?? '';

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
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _tts.speak(
                                        titleData + htmlToPlainText(bodyData),
                                        languageCode: languageCode,
                                      );
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
                                          fontSize: 16, color: Colors.black),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              HtmlWidget(
                                bodyData,
                                textStyle: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildAcknowledgementButton(context),
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

  Widget _buildAcknowledgementButton(BuildContext context) {
    final data = widget.resAllQuestion.data!.activity!;
    final no = widget.activityNo;

    return AcknowledgmentService.buildAcknowledgmentButton(
      context: context,
      selectedAcknowledgement: selectedAcknowledgement,
      secondaryColor: ColorPallete.secondary,
      onNext: () {
        switch (no) {
          case 0:
            Get.off(() =>
                UnderstandingScreen(resAllQuestion: widget.resAllQuestion));
            break;
          case 1:
            Get.off(() => MatchScreen(
                resAllQuestion: widget.resAllQuestion, showInstruction: false));
            break;
          case 2:
            Get.off(() => PictureUnderstandingScreen(
                showInstruction: false, resAllQuestion: widget.resAllQuestion));
            break;
          case 3:
            Get.off(
                () => PictureExpression(resAllQuestion: widget.resAllQuestion));
            break;
          case 4:
            Get.off(() => PictureSequencingsScreen(
                resAllQuestion: widget.resAllQuestion, showInstruction: false));
            break;
        }
      },
      onAcknowledge: (acknowledgement, score) async {
        setState(() {
          selectedAcknowledgement = acknowledgement;
          this.score = score;
        });

        final instructionId = switch (no) {
          0 => data.understandings!.instruction!.sId!,
          1 => data.matchings!.instruction!.sId!,
          2 => data.pictureUnderstandings!.instruction!.sId!,
          3 => data.pictureExpressions!.instruction!.sId!,
          4 => data.pictureSequencings!.instruction!.sId!,
          _ => ''
        };

        context.read<HomeBloc>().add(
              SubmitAcknowledgementRequest(
                acknowledgementRequest: AcknowledgementRequest(
                  activity: data.sId!,
                  acknowledgement: selectedAcknowledgement,
                  learningInstruction: instructionId,
                  score: score,
                ),
              ),
            );
      },
    );
  }
}
