import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/services/globals.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_bloc.dart';
import 'package:health_ed_flutter/modules/home/bloc/home_event.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';

import '../../../core/utils/custom_widgets.dart';

class DragDropScreen extends StatefulWidget {
  final ResAllQuestion resAllQuestion;
  const DragDropScreen({Key? key, required this.resAllQuestion})
      : super(key: key);
  @override
  _DragDropScreenState createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  String selectedLanguage = 'English';
  bool isDragging = false;
  String selectedAcknowledgement = 'Acknowledgement';
  Map<String, bool> matchedShapes = {
    "Circle": false,
    "Star": false,
    "Triangle": false,
  };

  void submittedAcknowledge() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                        AppBackButton(
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
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
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
                                      Navigator.of(context).pop(true);
                                    }, // Confirm
                                    child: Text('Confirm'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldExit == true) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Add sound play functionality here
                          },
                          child: Image.asset(
                            'assets/icons/volume_up1.png',
                            width: 40,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            'Match the given image',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Two columns for drag targets
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                _buildDraggable("Circle"),
                                SizedBox(width: 15),
                                Image.asset("assets/icons/blackArrow.png"),
                                SizedBox(width: 15),
                                _buildDragTarget("Circle"),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                _buildDraggable("Star"),
                                SizedBox(width: 15),
                                Image.asset("assets/icons/blackArrow.png"),
                                SizedBox(width: 15),
                                _buildDragTarget("Star"),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                _buildDraggable("Triangle"),
                                SizedBox(width: 15),
                                Image.asset("assets/icons/blackArrow.png"),
                                SizedBox(width: 15),
                                _buildDragTarget("Triangle"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraggable(String shape) {
    bool isMatched = matchedShapes[shape]!;
    return isMatched
        ? Opacity(
            opacity: 0.5,
            child: ShapeOption1(
              shape: shape,
              isHighlighted: false,
              backgroundColor: Colors.white,
              showCheck: false,
              originalImageOpacity: 1.0,
            ),
          )
        : Draggable<String>(
            data: shape,
            feedback: Opacity(
              opacity: 0.8,
              child: ShapeOption1(
                shape: shape,
                isHighlighted: false,
                backgroundColor: Colors.white,
                showCheck: false,
                originalImageOpacity: 1.0,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.5, // Reduce opacity when dragging
              child: ShapeOption1(
                shape: shape,
                isHighlighted: false,
                backgroundColor: Colors.white,
                showCheck: false,
                originalImageOpacity: 1.0,
              ),
            ),
            child: ShapeOption1(
              shape: shape,
              isHighlighted: false,
              backgroundColor: Colors.white,
              showCheck: false,
              originalImageOpacity: 1.0,
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

  Widget _buildDragTarget(String shape) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return ShapeOption1(
          shape: shape,
          isHighlighted: candidateData.isNotEmpty,
          backgroundColor:
              matchedShapes[shape]! ? ColorPallete.greenColor : Colors.white,
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

  void _showAcknowledgeDropdown(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Acknowledge Child’s Understanding'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Done';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Not Done'),
            onPressed: () {
              setState(() {
                selectedAcknowledgement = 'Not Done';
              });
              Navigator.pop(context);
            },
          )
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
                      {}
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
}

class ShapeOption1 extends StatelessWidget {
  final String shape;
  final bool isHighlighted;
  final Color backgroundColor;
  final bool showCheck;
  final double originalImageOpacity;

  const ShapeOption1({
    required this.shape,
    this.isHighlighted = false,
    this.backgroundColor = Colors.white,
    this.showCheck = false,
    this.originalImageOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 90,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Opacity(
                  opacity: originalImageOpacity,
                  child: Image.asset("assets/icons/$shape.png"),
                ),
              ),
              SizedBox(height: 4),
              // Text(
              //   shape,
              //   style: TextStyle(color: Colors.black, fontSize: 14),
              // ),
            ],
          ),
          if (showCheck)
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  final double dashWidth;
  final double dashSpacing;
  final Color color;

  const DottedLine({
    this.dashWidth = 4.0,
    this.dashSpacing = 4.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount =
            (constraints.constrainWidth() / (dashWidth + dashSpacing)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 2,
              color: color,
            );
          }),
        );
      },
    );
  }
}
