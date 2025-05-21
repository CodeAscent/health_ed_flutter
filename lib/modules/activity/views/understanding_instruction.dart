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
import 'package:health_ed_flutter/modules/activity/views/picture_expression_instruction.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/activity/views/understanding_screen.dart';

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
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    navigateIfNotAvailable();
  }

  void navigateIfNotAvailable() {
    final data = widget.resAllQuestion.data!.activity!;
    final no = widget.activityNo;

    final hasInstructionAndLearnings =
        (instruction, learnings) => instruction != null && learnings.isNotEmpty;

    switch (no) {
      case 0:
        if (!hasInstructionAndLearnings(data.understandings?.instruction,
            data.understandings?.learnings ?? [])) {
          Get.off(() => UnderstandingInstruction(
              resAllQuestion: widget.resAllQuestion, activityNo: 1));
        }
        break;
      case 1:
        if (!hasInstructionAndLearnings(
            data.matchings?.instruction, data.matchings?.learnings ?? [])) {
          Get.off(() => UnderstandingInstruction(
              resAllQuestion: widget.resAllQuestion, activityNo: 2));
        }
        break;
      case 2:
        if (!hasInstructionAndLearnings(data.pictureUnderstandings?.instruction,
            data.pictureUnderstandings?.learnings ?? [])) {
          Get.off(() => UnderstandingInstruction(
              resAllQuestion: widget.resAllQuestion, activityNo: 3));
        }
        break;
      case 3:
        if (!hasInstructionAndLearnings(data.pictureExpressions?.instruction,
            data.pictureExpressions?.learnings ?? [])) {
          Get.off(() => UnderstandingInstruction(
              resAllQuestion: widget.resAllQuestion, activityNo: 4));
        }
        break;
      case 4:
        if (!hasInstructionAndLearnings(data.pictureSequencings?.instruction,
            data.pictureSequencings?.learnings ?? [])) {
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              title: 'No Activity',
              message: 'No activity available',
            ),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Get.to(() =>
                UnderstandingScreen(resAllQuestion: widget.resAllQuestion));
            break;
          case 1:
            Get.to(() => MatchScreen(
                resAllQuestion: widget.resAllQuestion, showInstruction: false));
            break;
          case 2:
            Get.to(() => PictureUnderstandingScreen(
                showInstruction: false, resAllQuestion: widget.resAllQuestion));
            break;
          case 3:
            Get.to(() => PictureExpressionInstruction(
                resAllQuestion: widget.resAllQuestion));
            break;
          case 4:
            Get.to(() => PictureSequencingsScreen(
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
