import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/features/activity/views/MatchScreen.dart';
import 'package:health_ed_flutter/features/home/model/request/AcknowledgementRequest.dart';
import 'package:health_ed_flutter/features/home/model/response/ResUserAcknowledgement.dart';
import 'package:logger/logger.dart';

import '../../../../core/tts/text_to_speech.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../../../core/utils/helper.dart';
import '../../../activity/views/DragDropScreen.dart';
import '../../../activity/views/LearingVideoDescriptionScreen.dart';
import '../../../activity/views/PictureDescriptionScreen.dart';
import '../../../activity/views/PictureSequencings.dart';
import '../../../activity/views/RevealPictureDescriptionScreen.dart';
import '../../../activity/views/VideoDescriptionScreen.dart';
import '../../../activity/widgets/MediaSlider.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../bloc/VideoScreenBloc.dart';
import '../../bloc/VideoScreenEvent.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../../model/response/ResAllQuestion.dart';
import '../../repository/home_repository.dart';

class ActivityVideoUnderstandingScreen extends StatefulWidget {
  final ResAllQuestion resAllQuestion;

  ActivityVideoUnderstandingScreen({required this.resAllQuestion});

  @override
  _ActivityVideoUnderstandingScreenContentState createState() =>
      _ActivityVideoUnderstandingScreenContentState();
}


class _ActivityVideoUnderstandingScreenContentState extends State<ActivityVideoUnderstandingScreen> {
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
    learnings = widget.resAllQuestion!.data!.activity!.understandings!.learnings![currentIndex];
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void submittedAcknowledge(){
    if (widget.resAllQuestion.data!.activity!.matchings!
        .learnings!.length > 0) {
      Get.to(() =>
          MatchScreen(
            resAllQuestion: widget.resAllQuestion,));
    } else if (widget.resAllQuestion.data!.activity!
        .pictureSequencings!.learnings!.length > 0) {
      Get.off(() =>
          PictureSequencingsScreen(
            resAllQuestion: widget.resAllQuestion,));
    } else if (widget.resAllQuestion.data!.activity!
        .pictureUnderstandings!.learnings!.length > 0) {
      Get.off(() =>
          PictureDescriptionScreen(
              resAllQuestion: widget.resAllQuestion));
    } else if (widget.resAllQuestion.data!.activity!
        .pictureExpressions!.learnings!.length > 0) {
      Get.off(() =>
          LearingVideoDescriptionScreen(
            resAllQuestion: widget.resAllQuestion,));
    } else if (widget.resAllQuestion.data!.activity!
        .pictureExpressions!.learnings!.length > 0) {
      Get.off(() =>
          VideoDescriptionScreen(
            resAllQuestion: widget.resAllQuestion,));
    } else if (widget.resAllQuestion.data!.activity!
        .pictureExpressions!.learnings!.length > 0) {
      Get.off(() =>
          DragDropScreen(
            resAllQuestion: widget.resAllQuestion,));
    }
  }



  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetSubmitAcknowledgeResponseFailure) {
          customSnackbar(state.message, ContentType.failure);
        }
        else if (state is GetSubmitAcknowledgeResponse) {
          submittedAcknowledge();
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
                      child:
                      Column(
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
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  MediaSlider(
                                    mediaList: learnings.media!,),
                                  SizedBox(height: 20),
                                  _buildAcknowledgementButton(context),
                                ],
                              )
                          ),
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

  void _showAcknowledgeDropdown(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Acknowledge Child’s Understanding'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Not Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Not Understood';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Partially Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Partially Understood';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Understood';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Well Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Well Understood';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Fully Understood'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Fully Understood';
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


  Widget _buildDragDrop(){
    return Expanded(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is ActivityQuestionLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetAllQuestionSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildDraggable("Triangle"),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Drag Targets
                    _buildDragTarget("Circle"),
                    _buildDragTarget("Star"),
                    _buildDragTarget("Triangle"),
                  ],
                ),
                Spacer(),
              ],
            );
          } else if (state is GetAllQuestionFailure) {
            return Center(child: Text(state.message));
          }
          return CustomLoader();
        },
      ),
    );
  }

  Widget _buildAcknowledgementButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: ElevatedButton(
        onPressed: () {
          _showAcknowledgeDropdown(context);
        },
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
                      selectedAcknowledgement,
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
                      {
                        if(widget.resAllQuestion!.data!.activity!.understandings!.learnings!.length==currentIndex+1) {
                          context.read<HomeBloc>().add(SubmitAcknowledgementRequest(acknowledgementRequest: AcknowledgementRequest(activity:widget.resAllQuestion.data!.activity!.sId!,acknowledgement:"Understanding",learning: learnings.sId!,score: 1 )));
                        }else{
                        setState(() {
                            currentIndex +=1;
                            learnings= widget.resAllQuestion.data!.activity!.understandings!.learnings![currentIndex];

                          });
                        }
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: ColorPallete
                            .secondary,
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

  Widget _buildDragTarget(String shape) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return ShapeOption1(
          shape: shape,
          isHighlighted: candidateData.isNotEmpty,
          backgroundColor: matchedShapes[shape]! ? Colors.green : Colors.white,
          showCheck: matchedShapes[shape]!,
          originalImageOpacity: matchedShapes[shape]! ? 1.0 : 0.5,
        );
      },
      onWillAccept: (data) => !matchedShapes[shape]! && data == shape,
      onAccept: (data) {
        setState(() {
          matchedShapes[shape] = true; // Mark as matched
        });
      },
    );
  }

  Widget _buildDraggable(String shape) {
    bool isMatched = matchedShapes[shape]!;
    return isMatched
        ? Opacity(
      opacity: 0.5, // Reduced opacity after match
      child: Image.asset(
        "assets/icons/$shape.png",
        height: 110,
        width: 90,
      ),
    )
        : Draggable<String>(
      data: shape,
      feedback: Opacity(
        opacity: 0.8,
        child: Image.asset(
          "assets/icons/$shape.png",
          height: 110,
          width: 90,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5, // Reduce opacity when dragging
        child: Image.asset(
          "assets/icons/$shape.png",
          height: 110,
          width: 90,
        ),
      ),
      child: Image.asset(
        "assets/icons/$shape.png",
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
}
