import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/features/activity/views/PictureDescriptionScreen.dart';
import 'package:health_ed_flutter/features/home/model/response/ResAllQuestion.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/tts/text_to_speech.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../../core/utils/helper.dart';
import '../../home/widgets/ShapeOption.dart';
import 'DragDropScreen.dart';
import 'LearingVideoDescriptionScreen.dart';
import 'RevealPictureDescriptionScreen.dart';
import 'VideoDescriptionScreen.dart';

class PictureSequencingsScreen extends StatefulWidget {
  final ResAllQuestion resAllQuestion;

  const PictureSequencingsScreen({Key? key, required this.resAllQuestion})
      : super(key: key);

  @override
  _PictureSequencingState createState() => _PictureSequencingState();
}

class _PictureSequencingState extends State<PictureSequencingsScreen>
    with SingleTickerProviderStateMixin {
  String languageCode = "en-US";
  String selectedLanguage = 'English';
  final TextToSpeech _tts = TextToSpeech();
  bool isDragging = false;
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
    if (widget.resAllQuestion.data?.activity?.pictureSequencings?.instruction !=
        null) {
      instruction2 = widget
          .resAllQuestion.data!.activity!.pictureSequencings!.instruction!;
      showingInstruction = true;
    } else {
      instruction2 = widget
          .resAllQuestion.data!.activity!.pictureSequencings!.learnings!.first;
      showingInstruction = false;
    }

    for (var answer in instruction2.sequenceAudios!) {
      matchedShapes[answer.correctIndex!] = false;
    }

    if (showingInstruction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoMatchInstruction();
      });
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _autoMatchInstruction() async {
    if (showingInstruction && !isDragging) {
      final answers = instruction2.sequenceImages!;
      final questions = instruction2.sequenceAudios!;

      for (int i = 0; i < answers.length; i++) {
        final answer = answers[i];
        final correctIndex = answer.correctIndex!;
        final question = questions[correctIndex];

        double startX, startY, endX, endY;

        startX = MediaQuery.of(context).size.width * 0.2;
        startY = MediaQuery.of(context).size.height * (0.2 + (i * 0.15));
        endX = MediaQuery.of(context).size.width * 0.6;
        endY =
            MediaQuery.of(context).size.height * (0.2 + (correctIndex * 0.15));

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
            handX = startX + (endX - startX) * t;
            handY = startY + (endY - startY) * t;
          });
        }

        if (showingInstruction) {
          setState(() {
            matchedShapes[correctIndex] = true;
            showHand = false;
          });
        }

        await Future.delayed(Duration(milliseconds: 800));
      }

      setState(() {
        matchedShapes.clear();
        for (var question in questions) {
          matchedShapes[question.correctIndex!] = false;
        }
        showHand = false;
      });
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
                              GestureDetector(
                                onTap: () => _showCupertinoDropdown(context),
                                child: Row(
                                  children: [
                                    Text(selectedLanguage,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black)),
                                    Icon(
                                      CupertinoIcons.chevron_down,
                                      color: Colors.black,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
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
                  width: 50,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggable(String imageUrl, int currentIndex) {
    bool isMatched = matchedShapes[currentIndex]!;
    return isMatched
        ? Opacity(
            opacity: 0.5, // Reduced opacity after match
            child: Image.network(
              imageUrl,
              height: 110,
              width: 90,
            ),
          )
        : Draggable<String>(
            data: currentIndex.toString(),
            feedback: Opacity(
              opacity: 0.8,
              child: Image.network(
                imageUrl,
                height: 110,
                width: 90,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.5, // Reduce opacity when dragging
              child: Image.network(
                imageUrl,
                height: 110,
                width: 90,
              ),
            ),
            child: Image.network(
              imageUrl,
              height: 110,
              width: 90,
            ),
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
            onDragEnd: (details) {
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
      onWillAccept: (data) =>
          !matchedShapes[correctIndex]! && data == correctIndex.toString(),
      onAccept: (data) {
        setState(() {
          matchedShapes[correctIndex] = true; // Mark as matched
        });
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

  Widget _buildAcknowledgementButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Acknowledgement",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined,
                        color: ColorPallete.secondary),
                  ],
                ),
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.resAllQuestion.data!.activity!
                              .pictureSequencings!.learnings!.length ==
                          currentLearningIndex + 1) {
                        if (widget.resAllQuestion.data!.activity!
                                .pictureUnderstandings!.learnings!.length >
                            0) {
                          Get.to(() => PictureDescriptionScreen(
                              resAllQuestion: widget.resAllQuestion));
                        }  else if (widget.resAllQuestion.data!.activity!
                                .pictureExpressions!.learnings!.length >
                            0) {
                          Get.to(() => LearingVideoDescriptionScreen(
                                resAllQuestion: widget.resAllQuestion,
                              ));
                        } else if (widget.resAllQuestion.data!.activity!
                                .pictureExpressions!.learnings!.length >
                            0) {
                          Get.to(() => VideoDescriptionScreen(
                                resAllQuestion: widget.resAllQuestion,
                              ));
                        } else if (widget.resAllQuestion.data!.activity!
                                .pictureExpressions!.learnings!.length >
                            0) {
                          Get.to(() => DragDropScreen(
                                resAllQuestion: widget.resAllQuestion,
                              ));
                        }
                      } else {
                        _updateLearningData();
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: ColorPallete.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
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
                        SizedBox(width: 10),
                        Image.asset("assets/icons/blackArrow.png"),
                        SizedBox(width: 10),
                        _buildDragTarget(
                          answer.audio!,
                          answer.correctIndex!,
                        )
                      ],
                    ),
                    SizedBox(width: 20),
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
