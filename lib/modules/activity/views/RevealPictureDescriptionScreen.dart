import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/helper.dart';
import 'package:health_ed_flutter/modules/activity/views/picture_expression_instruction.dart';
import 'package:health_ed_flutter/modules/activity/views/pictureExpression.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';

import '../../../core/utils/custom_widgets.dart';
import 'DragDropScreen.dart';

class RevealPictureDescriptionScreen extends StatefulWidget {
  final ResAllQuestion resAllQuestion;
  const RevealPictureDescriptionScreen({Key? key, required this.resAllQuestion})
      : super(key: key);
  @override
  _PictureDescriptionScreenState createState() =>
      _PictureDescriptionScreenState();
}

class _PictureDescriptionScreenState
    extends State<RevealPictureDescriptionScreen> {
  String selectedLanguage = 'English';
  bool isDragging = false;
  String languageCode = "en-US";
  late Learnings1 instruction2;
  final TextToSpeech _tts = TextToSpeech();

  @override
  void initState() {
    super.initState();
    instruction2 = widget
        .resAllQuestion.data!.activity!.pictureUnderstandings!.learnings![1];
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBackButton(color: Colors.white),
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
                                fontSize: 12,
                                color: Colors.black,
                              ),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 227,
                  child: Image.network(
                    instruction2.media?.url ?? '',
                    fit: BoxFit.cover,
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
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/bg/imageActivity.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SizedBox(height: 5),
                Column(
                  children: instruction2.options?.map((option) {
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                instruction2.options
                                    ?.forEach((o) => o.correct = false);
                                option.correct = true;
                              });
                            },
                            child: Card(
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
                                                      color:
                                                          ColorPallete.primary,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                  )),
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                ),
                Spacer(),
                _buildAcknowledgementButton(context),
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

  Widget _buildAcknowledgementButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    onTap: () {
                      {
                        if (widget.resAllQuestion.data!.activity!
                                .pictureExpressions!.learnings!.length >
                            0) {
                          Get.to(() => PictureExpressionInstruction(
                                // showInstruction: true,
                                resAllQuestion: widget.resAllQuestion,
                              ));
                        } else if (widget.resAllQuestion.data!.activity!
                                .pictureExpressions!.learnings!.length >
                            0) {
                          Get.to(() => PictureExpression(
                                resAllQuestion: widget.resAllQuestion,
                              ));
                        } else if (widget.resAllQuestion.data!.activity!
                                .pictureExpressions!.learnings!.length >
                            0) {
                          Get.to(() => DragDropScreen(
                                resAllQuestion: widget.resAllQuestion,
                              ));
                        }
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
}
