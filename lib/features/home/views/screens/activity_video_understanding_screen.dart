import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';

import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/VideoScreenBloc.dart';
import '../../bloc/VideoScreenEvent.dart';

class ActivityVideoUnderstandingScreen extends StatefulWidget {
  @override
  _ActivityVideoUnderstandingScreenState createState() => _ActivityVideoUnderstandingScreenState();
}

class _ActivityVideoUnderstandingScreenState extends State<ActivityVideoUnderstandingScreen> {
  String selectedLanguage = 'English'; // Default language
  String selectedOption = 'Option 1'; // Default dropdown option

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScreenBloc(),
      child:
      SafeArea(
        child:Scaffold(
          body:Container(
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
                        ),
                        SizedBox(height: 10),
                        // Second Row: Speaker Icon and "Tiger" text
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
                        SizedBox(height: 10),
                        _buildSlider(),
                        SizedBox(height: 5),
                        _buildIndicator(),
                        SizedBox(height: 5),
                        _buildAcknowledgementButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
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
    return BlocBuilder<ScreenBloc, ScreenState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is SlideChangedState) {
          currentIndex = state.index;
        }

        return Expanded(
          child: PageView.builder(
            onPageChanged: (index) {
              context.read<ScreenBloc>().add(ChangeSlideEvent(index));
            },
            itemCount: 3, // Number of slides
            itemBuilder: (context, index) {
              return Image.asset('assets/bg/videoactivity.png'); // Replace with your images
            },
          ),
        );
      },
    );
  }

  Widget _buildIndicator() {
    return BlocBuilder<ScreenBloc, ScreenState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is SlideChangedState) {
          currentIndex = state.index;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              width: currentIndex == index ? 12.0 : 8.0, // Increase size for current index
              height: currentIndex == index ? 12.0 : 8.0, // Increase size for current index
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index ? ColorPallete.secondary : Colors.grey,
              ),
            );
          }),
        );
      },
    );
  }


  Widget _buildAcknowledgementButton(contxet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0), // Removed vertical padding
      child: ElevatedButton(
        onPressed: () {
          _showCupertinoDropdown(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Acknowledgement", style: TextStyle(fontSize: 18)),
              Icon(Icons.keyboard_arrow_down_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
