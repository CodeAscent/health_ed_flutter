import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/helper.dart';
import 'package:health_ed_flutter/modules/activity/views/understanding_instruction.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';

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
  const PictureUnderstandingScreen(
      {Key? key, required this.resAllQuestion, required this.showInstruction})
      : super(key: key);
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
  late Instruction instruction;
  int currentLearningIndex = 0;
  final TextToSpeech _tts = TextToSpeech();
  bool showingInstruction = true;
  bool isRevealed = false;
  @override
  void initState() {
    super.initState();
    navigateIfNotAvailable();
  }

  void navigateIfNotAvailable() {
    if (widget.resAllQuestion.data!.activity!.pictureUnderstandings!.learnings!
            .isEmpty &&
        widget.resAllQuestion.data!.activity!.pictureUnderstandings!
                .instruction ==
            null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() => PictureExpressionInstruction(
              resAllQuestion: widget.resAllQuestion,
            ));
      });
    } else {
      learning = widget.resAllQuestion.data!.activity!.pictureUnderstandings!
          .learnings![currentLearningIndex];
      activeImageUrl = learning.media?.url ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Preload initial image
        if (learning.media?.url != null && learning.media!.url!.isNotEmpty) {
          precacheImage(NetworkImage(learning.media!.url!), context);
        }

        // Preload all option images
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
    super.dispose();
  }

  void submittedAcknowledge() {
    if (widget.resAllQuestion.data!.activity!.pictureExpressions!.learnings!
            .length >
        0) {
      Get.off(() => PictureExpressionInstruction(
            resAllQuestion: widget.resAllQuestion,
            //  showInstruction: false,
          ));
    } else if (widget.resAllQuestion.data!.activity!.pictureExpressions!
            .learnings!.length >
        0) {
      Get.off(() => PictureExpression(
            resAllQuestion: widget.resAllQuestion,
          ));
    } else if (widget.resAllQuestion.data!.activity!.pictureExpressions!
            .learnings!.length >
        0) {
      Get.off(() => DragDropScreen(
            resAllQuestion: widget.resAllQuestion,
          ));
    }
  }

  void _updateLearningData() {
    setState(() {
      if (currentLearningIndex <
          widget.resAllQuestion.data!.activity!.pictureUnderstandings!
                  .learnings!.length -
              1) {
        currentLearningIndex++;
        learning = widget.resAllQuestion.data!.activity!.pictureUnderstandings!
            .learnings![currentLearningIndex];
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
            titleData = learning.title!.hi ?? "Instructions not available";
            break;
          case 'or':
            titleData = learning.title!.or ?? "Instructions not available";
            break;
          default:
            titleData = learning.title!.en ?? "Instructions not available";
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
                  children: [
                    // 🔹 Header (Language + Back button)
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
                                    onPressed: () => Navigator.of(context)
                                        .pop(false), // Cancel
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context)
                                        .pop(true), // Confirm
                                    child: Text('Confirm'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldExit == true) {
                              Navigator.of(context).pop(); // Exit the activity
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
                        //             fontSize: 12,
                        //             color: Colors.black,
                        //           ),
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

                    // 🔹 Title & TTS
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
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // 🔹 Main Image
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 227,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
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
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/bg/imageActivity.png',
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // 🔹 Scrollable Options Section
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: learning.options?.length ?? 0,
                        itemBuilder: (context, index) {
                          final option = learning.options![index];

                          String optionTitle;
                          switch (
                              getLanguageCode(selectedLanguage, languageCode)) {
                            case 'hi':
                              optionTitle = option.option?.hi ?? "NAN";
                              break;
                            case 'or':
                              optionTitle = option.option?.or ?? "NAN";
                              break;
                            default:
                              optionTitle = option.option?.en ?? "NAN";
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
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
                              child: learning.subType == "withOptions"
                                  ? Card(
                                      color: option.correct == true
                                          ? ColorPallete.primary
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _tts.speak(optionTitle,
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
                                                optionTitle,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        option.correct == true
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!isDragging) {
                                              setState(() {
                                                isDragging = true;
                                              });
                                            }
                                          },
                                          child: isDragging
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        _tts.speak(optionTitle,
                                                            languageCode:
                                                                languageCode);
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/volume_up1.png',
                                                        width: 40,
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      child: Text(
                                                        optionTitle,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: ColorPallete
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Center(
                                                  child: Text(
                                                    'Click to reveal answer',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 🔹 Acknowledgement Button at the Bottom
                    SizedBox(height: 2),
                    _buildAcknowledgementButton(context),
                    SizedBox(height: 10),
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
  Widget _buildAcknowledgementButton(BuildContext context) {
    bool isCompleted = widget.resAllQuestion.data!.activity!
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
                      )));
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

            // Get.to(() => PictureExpressionInstruction(
            //       resAllQuestion: widget.resAllQuestion,
            //       // showInstruction: false,
            //     ));
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
                    learningInstruction: learning.sId!,
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
                    learning: learning.sId!,
                    score: score,
                  ),
                ),
              );
        }
      },
    );
  }
}
