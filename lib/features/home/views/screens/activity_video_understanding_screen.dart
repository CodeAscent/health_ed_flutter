import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../../activity/views/DragDropScreen.dart';
import '../../bloc/VideoScreenBloc.dart';
import '../../bloc/VideoScreenEvent.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../../repository/home_repository.dart';

class ActivityVideoUnderstandingScreen extends StatelessWidget {
  final String activityId;

  const ActivityVideoUnderstandingScreen({Key? key, required this.activityId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HomeRepository())
        ..add(GetAllQuestionRequested(activityId: activityId)),
      child: ActivityVideoUnderstandingScreenContent(),
    );
  }
}

class ActivityVideoUnderstandingScreenContent extends StatefulWidget {
  const ActivityVideoUnderstandingScreenContent({Key? key}) : super(key: key);

  @override
  _ActivityVideoUnderstandingScreenContentState createState() =>
      _ActivityVideoUnderstandingScreenContentState();
}

class _ActivityVideoUnderstandingScreenContentState
    extends State<ActivityVideoUnderstandingScreenContent> {
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
                      // First Row: Back button and Language Dropdown
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
                      // Second Row: Speaker Icon and "Tiger" text
                      Expanded(
                        child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state is ActivityQuestionLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is GetAllQuestionSuccess) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Tiger',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  SizedBox(height: 5),
                                  _buildAcknowledgementButton(context),
                                ],
                              );
                            } else if (state is GetAllQuestionFailure) {
                              return Center(child: Text(state.message));
                            }
                            return CustomLoader();
                          },
                        ),
                      ),
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

  Widget _buildSlider() {
    int currentIndex = 0;
    return Expanded(
        child: Column(
      children: [
        PageView.builder(
          onPageChanged: (index) {
            context.read<ScreenBloc>().add(ChangeSlideEvent(index));
          },
          itemCount: 3, // Number of slides
          itemBuilder: (context, index) {
            return Image.asset('assets/bg/videoactivity.png');},
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              width: currentIndex == index
                  ? 12.0
                  : 8.0, // Increase size for current index
              height: currentIndex == index
                  ? 12.0
                  : 8.0, // Increase size for current index
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index
                    ? ColorPallete.secondary
                    : Colors.grey,
              ),
            );
          }),
        )
      ],
    ));
  }

  Widget _buildAcknowledgementButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: ElevatedButton(
        onPressed: () {
          _showCupertinoDropdown(context);
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
                    onTap: () {},
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: ColorPallete
                            .secondary, // Change to your desired color
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
        return ShapeOption(
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
