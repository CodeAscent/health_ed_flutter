import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/modules/activity/views/PictureUnderstandingScreen.dart';
import 'package:health_ed_flutter/modules/activity/views/PictureSequencings.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:logger/logger.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/tts/text_to_speech.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../../core/utils/helper.dart';
import '../../home/widgets/ShapeOption.dart';
import 'DragDropScreen.dart';
import 'picture_expression_instruction.dart';
import 'RevealPictureDescriptionScreen.dart';
import 'pictureExpression.dart';

class MatchScreen extends StatefulWidget {
  final bool showInstruction;
  final ResAllQuestion resAllQuestion;

  const MatchScreen(
      {Key? key, required this.resAllQuestion, required this.showInstruction})
      : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  String languageCode = "en-US";
  String selectedLanguage = 'English';
  final TextToSpeech _tts = TextToSpeech();
  bool isDragging = false;
  late Learnings3 learnings3;
  int currentIndex = 0;

  Map<int, bool> matchedShapes = {};

  double handX = 0.0;
  double handY = 0.0;
  bool showHand = false;
  late bool showingInstruction;
  @override
  void initState() {
    super.initState();
    navigateIfNotAvailable();
    showingInstruction = widget.showInstruction;
    if (showingInstruction) {
      learnings3 =
          widget.resAllQuestion.data!.activity!.matchings!.instruction!;
    } else {
      learnings3 = widget
          .resAllQuestion.data!.activity!.matchings!.learnings![currentIndex];
    }

    for (var answer in learnings3.matchingQuestions!) {
      matchedShapes[answer.correctIndex!] = false;
    }

    if (showingInstruction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoMatchInstruction();
      });
    }
  }

  navigateIfNotAvailable() {
    if (widget.resAllQuestion.data!.activity!.matchings!.learnings!.isEmpty 
          &&
        widget.resAllQuestion.data!.activity!.matchings!.instruction == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() => PictureUnderstandingScreen(
              resAllQuestion: widget.resAllQuestion,
              showInstruction: true,
            ));
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
      final answers = learnings3.matchingAnswers!;
      final questions = learnings3.matchingQuestions!;

      for (int i = 0; i < answers.length; i++) {
        final answer = answers[i];
        final correctIndex = answer.correctIndex!;
        final question = questions[correctIndex];

        // Calculate positions based on layout direction
        double startX, startY, endX, endY;
        if (learnings3.direction == 'vertical') {
          // For vertical layout:
          // Start from top row (answers) to bottom row (questions)
          startX = MediaQuery.of(context).size.width * (0.25 + (i * 0.25));
          startY = MediaQuery.of(context).size.height * 0.35;
          endX = MediaQuery.of(context).size.width *
              (0.25 + (correctIndex * 0.25));
          endY = MediaQuery.of(context).size.height * 0.5;
        } else {
          // For horizontal layout:
          // Start from left column (answers) to right column (questions)
          startX = MediaQuery.of(context).size.width * 0.25;
          startY = MediaQuery.of(context).size.height * (0.35 + (i * 0.15));
          endX = MediaQuery.of(context).size.width * 0.65;
          endY = MediaQuery.of(context).size.height *
              (0.35 + (correctIndex * 0.15));
        }

        // Show hand at starting position
        setState(() {
          showHand = true;
          handX = startX - 25; // Offset to center hand on the image
          handY = startY - 25;
        });

        await Future.delayed(Duration(milliseconds: 500));

        // Animate hand movement
        for (double t = 0; t <= 1; t += 0.05) {
          if (!showingInstruction) break;

          await Future.delayed(Duration(milliseconds: 50));

          setState(() {
            // Use cubic easing for smoother animation
            double cubicT = t * t * (3 - 2 * t);
            handX = startX + (endX - startX) * cubicT - 25;
            handY = startY + (endY - startY) * cubicT - 25;
          });
        }

        // Mark as matched and hide hand
        if (showingInstruction) {
          setState(() {
            matchedShapes[correctIndex] = true;
            showHand = false;
          });
        }

        await Future.delayed(Duration(milliseconds: 800));
      }

      // Reset matches after instruction
      if (showingInstruction) {
        setState(() {
          matchedShapes.clear();
          for (var question in questions) {
            matchedShapes[question.correctIndex!] = false;
          }
          showHand = false;
        });
      }
    }
  }

  void _updateLearningData() {
    setState(() {
      if (currentIndex <
          widget.resAllQuestion.data!.activity!.matchings!.learnings!.length -
              1) {
        currentIndex++;
        learnings3 = widget
            .resAllQuestion.data!.activity!.matchings!.learnings![currentIndex];
        selectedAcknowledgement = 'Acknowledgement';
      }

      matchedShapes.clear();
      for (var answer in learnings3.matchingQuestions!) {
        matchedShapes[answer.correctIndex!] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String titleData;

    switch (getLanguageCode(selectedLanguage, languageCode)) {
      case 'hi':
        titleData = learnings3.title!.hi ?? "Instructions not available";
        break;
      case 'or':
        titleData = learnings3.title!.or ?? "Instructions not available";
        break;
      default:
        titleData = learnings3.title!.en ?? "Instructions not available";
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

  // Method to build draggable for each shape
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
        return ShapeOption(
          shape: imageUrl,
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

  String selectedAcknowledgement = 'Acknowledgement';
  int score = 0;
  Widget _buildAcknowledgementButton(BuildContext context) {
    bool isCompleted =
        widget.resAllQuestion.data!.activity!.matchings!.learnings!.length ==
            currentIndex + 1;

    return AcknowledgmentService.buildAcknowledgmentButton(
      context: context,
      selectedAcknowledgement: selectedAcknowledgement,
      secondaryColor: ColorPallete.secondary,
      onNext: () {
        if (widget.showInstruction == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MatchScreen(
                        resAllQuestion: widget.resAllQuestion,
                        showInstruction: false,
                      )));
        } else {
          if (isCompleted) {
            Get.to(() => PictureUnderstandingScreen(
                  resAllQuestion: widget.resAllQuestion,
                  showInstruction: true,
                ));
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

        if (widget.showInstruction == true) {
          context.read<HomeBloc>().add(
                SubmitAcknowledgementRequest(
                  acknowledgementRequest: AcknowledgementRequest(
                    activity: widget.resAllQuestion.data!.activity!.sId!,
                    acknowledgement: acknowledgement,
                    learningInstruction: learnings3.sId!,
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
                    learning: learnings3.sId!,
                    score: score,
                  ),
                ),
              );
        }
      },
    );
  }

  Widget _buildMatchingContent() {
    if (learnings3.direction == 'vertical') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Top row for answers in horizontal layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: learnings3.matchingAnswers!.map((question) {
              return _buildDraggable(
                question.image!,
                question.correctIndex!,
              );
            }).toList(),
          ),
          SizedBox(height: 40),
          // Bottom row for questions in horizontal layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: learnings3.matchingQuestions!.map((answer) {
              return _buildDragTarget(
                answer.image!,
                answer.correctIndex!,
              );
            }).toList(),
          ),
        ],
      );
    } else {
      // Vertical layout
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left column for answers in vertical layout
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: learnings3.matchingAnswers!.map((question) {
              return _buildDraggable(
                question.image!,
                question.correctIndex!,
              );
            }).toList(),
          ),
          SizedBox(width: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: learnings3.matchingQuestions!.map((answer) {
              return _buildDragTarget(
                answer.image!,
                answer.correctIndex!,
              );
            }).toList(),
          ),
        ],
      );
    }
  }
}
