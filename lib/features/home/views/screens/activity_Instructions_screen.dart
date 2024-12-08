import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/features/home/views/screens/activity_video_understanding_screen.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../../repository/home_repository.dart';

class ActivityInstructionsScreen extends StatelessWidget {
  final String activityId;

  const ActivityInstructionsScreen({Key? key, required this.activityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HomeRepository())..add(GetActivityInstructionRequested(activityId: activityId)),
      child: ActivityInstructionContent(activityId: activityId),
    );
  }
}

class ActivityInstructionContent extends StatelessWidget {
  final String activityId;

  const ActivityInstructionContent({Key? key, required this.activityId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bg/auth_bg.png'),
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
                          children: [
                            AppBackButton(),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Instructions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            _buildLanguageDropdown(context),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                // Add sound play functionality
                              },
                              child: Image.asset(
                                'assets/icons/volume_up1.png',
                                width: 40,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              if (state is ActivityInstructionLoading) {
                                return Center(child: CircularProgressIndicator());
                              } else if (state is GetActivityInstructionSuccess) {
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      HtmlWidget(
                                        state.resActivityInstructions.data!.instructions!.hi!,
                                        textStyle: TextStyle(fontSize: 14, color: ColorPallete.greyColor),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (state is GetActivityInstructionFailure) {
                                return Center(child: Text(state.message));
                              }
                              return CustomLoader();
                            },
                          ),
                        ),
                        CustomGradientButton(
                          label: 'Done',
                          onTap: () {
                            Get.to(() => ActivityVideoUnderstandingScreen(activityId:activityId,));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCupertinoDropdown(context),
      child: Container(
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
        child: Row(
          children: [
            Text(
              "selectedLanguage",
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
    );
  }

  void _showCupertinoDropdown(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Select Language'),
        actions: <Widget>[
          _buildLanguageOption('Hindi'),
          _buildLanguageOption('English'),
          _buildLanguageOption('Odia'),
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

  CupertinoActionSheetAction _buildLanguageOption(String language) {
    return CupertinoActionSheetAction(
      child: Text(language),
      onPressed: () {
        // setState(() {
        //   selectedLanguage = language;
        // });
        // Navigator.pop(context);
      },
    );
  }
}
