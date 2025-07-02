/// Updated PictureUnderstandingScreen with responsiveness for mobile and tablet.
/// Ensures original design and features are preserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/core/services/globals.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/helper.dart';
import 'package:health_ed_flutter/modules/activity/views/understanding_instruction.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/utils/custom_snackbar.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';
import '../../home/bloc/home_state.dart';
import '../../home/model/request/AcknowledgementRequest.dart';
import 'DragDropScreen.dart';
import 'picture_expression_instruction.dart';
import 'pictureExpression.dart';

class PictureUnderstandingScreen extends StatefulWidget {
  final ResAllQuestion resAllQuestion;
  final bool showInstruction;
  const PictureUnderstandingScreen({
    Key? key,
    required this.resAllQuestion,
    required this.showInstruction,
  }) : super(key: key);

  @override
  _PictureUnderstandingScreenState createState() =>
      _PictureUnderstandingScreenState();
}

class _PictureUnderstandingScreenState
    extends State<PictureUnderstandingScreen> {
  String selectedLanguage = 'English';
  bool isDragging = false;
  String selectedAcknowledgement = 'Acknowledgement';
  String languageCode = "en-US";
  String activeImageUrl = "";
  late Learnings1 learning;
  AudioPlayer audioPlayer = AudioPlayer();
  late Instruction instruction;
  int currentLearningIndex = 0;
  final TextToSpeech _tts = TextToSpeech();
  bool isRevealed = false;

  @override
  void initState() {
    super.initState();
    navigateIfNotAvailable();
  }

  void navigateIfNotAvailable() {
    final pu = widget.resAllQuestion.data!.activity!.pictureUnderstandings!;
    if (pu.learnings!.isEmpty && pu.instruction == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() => PictureExpressionInstruction(
            resAllQuestion: widget.resAllQuestion));
      });
    } else {
      learning = pu.learnings![currentLearningIndex];
      activeImageUrl = learning.media?.url ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (learning.media?.url != null && learning.media!.url!.isNotEmpty) {
          precacheImage(NetworkImage(learning.media!.url!), context);
        }
        learning.options?.forEach((option) {
          final imageUrl = option.media?.url;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            precacheImage(NetworkImage(imageUrl), context);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _tts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void _playMatchSound({required bool success}) async {
    final asset = success ? 'assets/bg/awsm.mp3' : 'assets/bg/sad.mp3';
    if (audioPlayer.playing) await audioPlayer.pause();
    await audioPlayer.stop();
    await audioPlayer.setAsset(asset);
    await audioPlayer.play();
  }

  void _updateLearningData() {
    setState(() {
      final pu = widget.resAllQuestion.data!.activity!.pictureUnderstandings!;
      if (currentLearningIndex < pu.learnings!.length - 1) {
        currentLearningIndex++;
        learning = pu.learnings![currentLearningIndex];
        activeImageUrl = learning.media?.url ?? '';

        precacheImage(NetworkImage(learning.media?.url ?? ""), context);
        learning.options?.forEach((option) {
          final imageUrl = option.media?.url;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            precacheImage(NetworkImage(imageUrl), context);
          }
        });
      }
    });
  }

  Widget _buildAcknowledgementButton(BuildContext context) {
    final isCompleted = widget.resAllQuestion.data!.activity!
            .pictureUnderstandings!.learnings!.length ==
        currentLearningIndex + 1;
    return AcknowledgmentService.buildAcknowledgmentButton(
      context: context,
      selectedAcknowledgement: selectedAcknowledgement,
      secondaryColor: ColorPallete.primary,
      onNext: () {
        if (widget.showInstruction == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PictureUnderstandingScreen(
                resAllQuestion: widget.resAllQuestion,
                showInstruction: false,
              ),
            ),
          );
        } else {
          if (!widget.showInstruction && isCompleted) {
            Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(
                builder: (_) => UnderstandingInstruction(
                  key: ValueKey('activity_3'),
                  resAllQuestion: widget.resAllQuestion,
                  activityNo: 3,
                ),
              ),
            );
          } else {
            _updateLearningData();
          }
        }
      },
      onAcknowledge: (acknowledgement, score) async {
        _playMatchSound(success: acknowledgement == 'Done');
        setState(() {
          selectedAcknowledgement = acknowledgement;
        });
        final act = widget.resAllQuestion.data!.activity!;
        context.read<HomeBloc>().add(
              SubmitAcknowledgementRequest(
                acknowledgementRequest: AcknowledgementRequest(
                  activity: act.sId!,
                  acknowledgement: acknowledgement,
                  score: score,
                  learning: !widget.showInstruction ? learning.sId! : null,
                  learningInstruction:
                      widget.showInstruction ? learning.sId! : null,
                ),
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    String titleData;
    switch (getLanguageCode(selectedLanguage, languageCode)) {
      case 'hi':
        titleData = learning.title?.hi ?? "Instructions not available";
        break;
      case 'or':
        titleData = learning.title?.or ?? "Instructions not available";
        break;
      default:
        titleData = learning.title?.en ?? "Instructions not available";
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
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBackButton(
                        color: Colors.white,
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
                                        Navigator.pop(context, false),
                                    child: Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () {
                                    if (selectedDayName != null) {
                                      context.read<HomeBloc>().add(
                                          GetAllActivityRequested(
                                              activityId: selectedDayId!));
                                      Get.back();
                                    } else {
                                      Get.off(() => AllQuizzesScreen());
                                    }
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Confirm'),
                                )
                              ],
                            ),
                          );

                          if (shouldExit == true) Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 20 : 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _tts.speak(titleData, languageCode: languageCode),
                        child: Image.asset('assets/icons/volume_up1.png',
                            width: 40),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          titleData,
                          style: TextStyle(
                            fontSize: isTablet ? 24 : 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 5,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: isTablet ? 30 : 20),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: isTablet ? 50 : 20),
                      width: isTablet
                          ? constraints.maxWidth * 0.5
                          : constraints.maxWidth * 0.9,
                      height: isTablet
                          ? constraints.maxHeight * 0.4
                          : constraints.maxHeight * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          activeImageUrl,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/bg/imageActivity.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: isTablet ? 50 : 16),
                      itemCount: learning.options?.length ?? 0,
                      itemBuilder: (context, index) {
                        final option = learning.options![index];
                        String optionTitle;
                        switch (
                            getLanguageCode(selectedLanguage, languageCode)) {
                          case 'hi':
                            optionTitle = option.option?.hi ?? 'NAN';
                            break;
                          case 'or':
                            optionTitle = option.option?.or ?? 'NAN';
                            break;
                          default:
                            optionTitle = option.option?.en ?? 'NAN';
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                learning.options
                                    ?.forEach((o) => o.correct = false);
                                option.correct = true;
                                if (learning.subType == "withOptions" &&
                                    option.media?.url != null) {
                                  activeImageUrl = option.media!.url!;
                                }
                              });
                            },
                            child: Card(
                              color: option.correct == true
                                  ? ColorPallete.primary
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _tts.speak(optionTitle,
                                          languageCode: languageCode),
                                      child: Image.asset(
                                          'assets/icons/volume_up1.png',
                                          width: 40),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Text(
                                        optionTitle,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: option.correct == true
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildAcknowledgementButton(context),
                  SizedBox(height: 10),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
