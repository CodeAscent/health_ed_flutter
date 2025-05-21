import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/helper.dart';
import 'package:health_ed_flutter/modules/activity/views/PictureSequencings.dart';
import 'package:health_ed_flutter/modules/activity/views/pictureExpression.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';
import '../../home/bloc/home_state.dart';
import '../../home/model/request/AcknowledgementRequest.dart';

class PictureExpressionInstruction extends StatefulWidget {
  final ResAllQuestion resAllQuestion;

  const PictureExpressionInstruction({Key? key, required this.resAllQuestion})
      : super(key: key);

  @override
  _PictureExpressionInstructionState createState() =>
      _PictureExpressionInstructionState();
}

class _PictureExpressionInstructionState
    extends State<PictureExpressionInstruction> {
  String selectedLanguage = 'English';
  String languageCode = "en-US";
  bool isLoading = true;
  String selectedAcknowledgement = 'Acknowledgement';
  int score = 0;
  late Learnings1 learnings1;
  late Instruction instruction;
  final TextToSpeech _tts = TextToSpeech();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initInstruction());
  }

  void initInstruction() {
    final expressions =
        widget.resAllQuestion.data!.activity!.pictureExpressions;
    if (expressions!.learnings!.isEmpty && expressions.instruction == null) {
      Get.off(() => PictureSequencingsScreen(
            resAllQuestion: widget.resAllQuestion,
            showInstruction: true,
          ));
    } else {
      setState(() {
        instruction = expressions.instruction!;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final titleData = getLocalizedTitle();

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetSubmitAcknowledgeResponseFailure) {
          customSnackbar(state.message, ContentType.failure);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/bg/videobg.png'),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _tts.speak(titleData, languageCode: languageCode);
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 227,
                      child: Image.network(
                        learnings1.media?.url ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/bg/imageActivity.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomGradientButton(
                        isDisabled:
                            selectedAcknowledgement == 'Acknowledgement',
                        label: 'Done Watching?',
                        onTap: () {
                          if (selectedAcknowledgement != 'Acknowledgement') {
                            Get.to(() => PictureExpression(
                                  resAllQuestion: widget.resAllQuestion,
                                ));
                          }
                        },
                      ),
                    ),
                    Spacer(),
                    _buildAcknowledgementButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBackButton(color: Colors.white),
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
      ],
    );
  }

  Widget _buildAcknowledgementButton(BuildContext context) {
    return AcknowledgmentService.buildAcknowledgmentButton(
      context: context,
      selectedAcknowledgement: selectedAcknowledgement,
      secondaryColor: Colors.white,
      onNext: () {},
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
                  learningInstruction: learnings1.sId!,
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

  String getLocalizedTitle() {
    final title = learnings1.title;
    switch (getLanguageCode(selectedLanguage, languageCode)) {
      case 'hi':
        return title?.hi ?? "Instructions not available";
      case 'or':
        return title?.or ?? "Instructions not available";
      default:
        return title?.en ?? "Instructions not available";
    }
  }
}
