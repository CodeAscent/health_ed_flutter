import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/modules/activity/views/MatchScreen.dart';
import 'package:health_ed_flutter/modules/activity/views/PictureUnderstandingScreen.dart';
import 'package:health_ed_flutter/modules/auth/models/response/OtpVerifyResponse.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/shared_widget/activity_congrats_popup.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/tts/text_to_speech.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../../core/utils/helper.dart';
import '../../home/widgets/ShapeOption.dart';

class PictureSequencingsScreen extends StatefulWidget {
  final bool showInstruction;
  final ResAllQuestion resAllQuestion;

  PictureSequencingsScreen(
      {Key? key, required this.resAllQuestion, required this.showInstruction})
      : super(key: key);

  @override
  _PictureSequencingState createState() => _PictureSequencingState();
}

class _PictureSequencingState extends State<PictureSequencingsScreen>
    with SingleTickerProviderStateMixin {
  String languageCode = "en-US";
  String selectedLanguage = 'English';
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  final TextToSpeech _tts = TextToSpeech();
  bool isDragging = false;
  late Instruction instruction;
  late Instruction2 instruction2;
  int currentLearningIndex = 0;
  bool showingInstruction = true;

  Map<int, bool> matchedShapes = {};

  double handX = 0.0;
  double handY = 0.0;
  bool showHand = false;

  @override
  void initState() {
    super.initState();

    instruction2 = widget
        .resAllQuestion.data!.activity!.pictureSequencings!.learnings!.first;

    for (var answer in instruction2.sequenceAudios!) {
      matchedShapes[answer.correctIndex!] = false;
    }

    // if (showingInstruction) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _autoMatchInstruction();
    //   });
    // }
  }

  @override
  void dispose() {
    _tts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void _playMatchSound({required bool success}) {
    final asset = success ? 'assets/bg/awsm.mp3' : 'assets/bg/sad.mp3';
    toggleAudio(asset);
  }

  void toggleAudio(String url) async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.stop();
      await audioPlayer.setAsset(url);
      await audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _autoMatchInstruction() async {
    if (showingInstruction && !isDragging) {
      final answers = instruction2.sequenceImages!;
      final questions = instruction2.sequenceAudios!;

      for (int i = 0; i < answers.length; i++) {
        final answer = answers[i];
        final correctIndex = answer.correctIndex!;
        final question = questions[correctIndex];

        // Calculate positions based on the actual layout
        double startX =
            MediaQuery.of(context).size.width * 0.2; // Left side position
        double startY = MediaQuery.of(context).size.height * (0.3 + (i * 0.15));
        double endX =
            MediaQuery.of(context).size.width * 0.75; // Right side position
        double endY =
            MediaQuery.of(context).size.height * (0.3 + (correctIndex * 0.15));

        setState(() {
          showHand = true;
          handX = startX;
          handY = startY;
        });

        await Future.delayed(Duration(milliseconds: 500));

        for (double t = 0; t <= 1; t += 0.05) {
          if (!showingInstruction) break;

          await Future.delayed(Duration(milliseconds: 50));

          setState(() {
            double cubicT = t * t * (3 - 2 * t); // Smooth easing
            handX = startX + (endX - startX) * cubicT;
            handY = startY + (endY - startY) * cubicT;
          });
        }

        if (showingInstruction) {
          setState(() {
            matchedShapes[correctIndex] = true;
            showHand = false;
          });

          await Future.delayed(Duration(milliseconds: 800));
        }
      }

      if (showingInstruction) {
        setState(() {
          matchedShapes.clear();
          for (var question in questions) {
            matchedShapes[question.correctIndex!] = false;
          }
          showHand = false;
        });

        _updateLearningData();
      }
    }
  }

  void _updateLearningData() {
    setState(() {
      if (showingInstruction) {
        showingInstruction = false;
        currentLearningIndex = 0;
        instruction2 = widget.resAllQuestion.data!.activity!.pictureSequencings!
            .learnings![currentLearningIndex];
      } else {
        if (currentLearningIndex <
            widget.resAllQuestion.data!.activity!.matchings!.learnings!.length -
                1) {
          currentLearningIndex++;
          instruction2 = widget.resAllQuestion.data!.activity!
              .pictureSequencings!.learnings![currentLearningIndex];
        }
      }

      matchedShapes.clear();
      for (var answer in instruction2.sequenceAudios!) {
        matchedShapes[answer.correctIndex!] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleData;

    switch (getLanguageCode(selectedLanguage, languageCode)) {
      case 'hi':
        titleData = instruction2.title!.hi ?? "Instructions not available";
        break;
      case 'or':
        titleData = instruction2.title!.or ?? "Instructions not available";
        break;
      default:
        titleData = instruction2.title!.en ?? "Instructions not available";
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
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
                              // GestureDetector(
                              //   onTap: () => _showCupertinoDropdown(context),
                              //   child: Row(
                              //     children: [
                              //       Text(selectedLanguage,
                              //           style: TextStyle(
                              //               fontSize: 12, color: Colors.black)),
                              //       Icon(
                              //         CupertinoIcons.chevron_down,
                              //         color: Colors.black,
                              //         size: 14,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: 10),
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          _buildMatchingContent(),
                          Spacer(),
                          _buildAcknowledgementButton(context),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showHand)
              Positioned(
                left: handX,
                top: handY,
                child: Image.asset(
                  'assets/icons/hand.png',
                  width: 40,
                  height: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggable(String imageUrl, int currentIndex) {
    bool isMatched = matchedShapes[currentIndex]!;

    Widget imageContainer({required double opacity}) {
      return Container(
        height: 90,
        width: 90,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isMatched ? Colors.green : Colors.transparent,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(opacity),
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.error)),
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
          ),
        ),
      );
    }

    return Draggable<String>(
      data: currentIndex.toString(),
      feedback: imageContainer(opacity: 0.8),
      childWhenDragging: isMatched
          ? imageContainer(opacity: 0.5)
          : imageContainer(opacity: 1.0),
      child: isMatched
          ? imageContainer(opacity: 0.5)
          : imageContainer(opacity: 1.0),
      onDragStarted: () {
        setState(() {
          isDragging = true;
        });
      },
      onDraggableCanceled: (_, __) {
        setState(() {
          isDragging = false;
        });
      },
      onDragEnd: (_) {
        setState(() {
          isDragging = false;
        });
      },
    );
  }

  Widget _buildDragTarget(String imageUrl, int correctIndex) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return AudioOption(
          audio: imageUrl,
          isHighlighted: candidateData.isNotEmpty,
          showCheck: matchedShapes[correctIndex]!,
          originalImageOpacity: matchedShapes[correctIndex]! ? 1.0 : 0.5,
        );
      },
      onWillAccept: (data) {
        bool willAccept =
            !matchedShapes[correctIndex]! && data == correctIndex.toString();
        return true; // always allow drop to check result manually
      },
      onAccept: (data) {
        bool isMatch = data == correctIndex.toString();
        setState(() {
          matchedShapes[correctIndex] = isMatch;
        });

        _playMatchSound(success: isMatch);
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

  String selectedAcknowledgement = 'Acknowledgement';
  int score = 0;

  Widget _buildAcknowledgementButton(BuildContext context) {
    bool isCompleted = widget.resAllQuestion.data!.activity!.pictureSequencings!
                .learnings!.length -
            1 ==
        currentLearningIndex;
    return AcknowledgmentService.buildAcknowledgmentButton(
        context: context,
        selectedAcknowledgement: selectedAcknowledgement,
        secondaryColor: ColorPallete.secondary,
        onNext: () {
          if (widget.showInstruction == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PictureSequencingsScreen(
                          resAllQuestion: widget.resAllQuestion,
                          showInstruction: false,
                        )));
          } else {
            if (isCompleted) {
              Get.dialog(
                ActivityCongratsPopup(
                  activityId: widget.resAllQuestion.data!.activity!.sId!,
                ),
                barrierDismissible: false,
              );
            } else {
              _updateLearningData();
            }
          }
        },
        onAcknowledge: (acknowledgement, score) async {
          setState(() {
            selectedAcknowledgement = acknowledgement;
            this.score = score;
          });
          if (widget.showInstruction) {
            context.read<HomeBloc>().add(
                  SubmitAcknowledgementRequest(
                    acknowledgementRequest: AcknowledgementRequest(
                      activity: widget.resAllQuestion.data!.activity!.sId!,
                      acknowledgement: acknowledgement,
                      learningInstruction: instruction2.sId!,
                      score: score,
                    ),
                  ),
                );
          } else {
            context.read<HomeBloc>().add(
                  SubmitAcknowledgementRequest(
                    acknowledgementRequest: AcknowledgementRequest(
                      activity: widget.resAllQuestion.data!.activity!.sId!,
                      acknowledgement: acknowledgement,
                      learning: instruction2.sId!,
                      score: score,
                    ),
                  ),
                );
          }
        });
  }

  Widget _buildMatchingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children:
                  instruction2.sequenceImages!.asMap().entries.map((entry) {
                final question = entry.value;
                final answer = instruction2.sequenceAudios![entry.key];
                return Column(
                  children: [
                    Row(
                      children: [
                        _buildDraggable(
                          question.image!,
                          question.correctIndex!,
                        ),
                        SizedBox(width: 4),
                        Image.asset("assets/icons/blackArrow.png"),
                        SizedBox(width: 4),
                        _buildDragTarget(
                          answer.audio!,
                          answer.correctIndex!,
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
