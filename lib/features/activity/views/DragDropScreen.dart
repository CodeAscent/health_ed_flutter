import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

import '../../../core/utils/custom_widgets.dart';

class DragDropScreen extends StatefulWidget {
  @override
  _DragDropScreenState createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  String selectedLanguage = 'English';
  bool isDragging = false;

  // Track the matched shapes
  Map<String, bool> matchedShapes = {
    "Circle": false,
    "Star": false,
    "Triangle": false,
  };

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
                    SizedBox(height: 20,),
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

  // Method to build draggable for each shape
  Widget _buildDraggable(String shape) {
    bool isMatched = matchedShapes[shape]!;
    return isMatched
        ? Opacity(
      opacity: 0.5, // Reduced opacity after match
      child:  ShapeOption(
        shape: shape,
        isHighlighted: false,
        backgroundColor: Colors.white,
        showCheck: false,
        originalImageOpacity:1.0,
      ),
    )
        : Draggable<String>(
      data: shape,
      feedback: Opacity(
        opacity: 0.8,
        child:ShapeOption(
          shape: shape,
          isHighlighted: false,
          backgroundColor: Colors.white,
          showCheck: false,
          originalImageOpacity:1.0,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5, // Reduce opacity when dragging
        child: ShapeOption(
          shape: shape,
          isHighlighted: false,
          backgroundColor: Colors.white,
          showCheck: false,
          originalImageOpacity:1.0,
        ),
      ),
      child: ShapeOption(
        shape: shape,
        isHighlighted: false,
        backgroundColor: Colors.white,
        showCheck: false,
        originalImageOpacity:1.0,
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

  // Method to build drag targets for each shape
  Widget _buildDragTarget(String shape) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return ShapeOption(
          shape: shape,
          isHighlighted: candidateData.isNotEmpty,
          backgroundColor: matchedShapes[shape]! ? ColorPallete.greenColor : Colors.white,
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
}

class ShapeOption extends StatelessWidget {
  final String shape;
  final bool isHighlighted;
  final Color backgroundColor;
  final bool showCheck;
  final double originalImageOpacity;

  const ShapeOption({
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
        final dashCount = (constraints.constrainWidth() / (dashWidth + dashSpacing)).floor();
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
