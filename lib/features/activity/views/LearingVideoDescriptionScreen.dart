import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/helper.dart';
import 'package:health_ed_flutter/features/activity/views/VideoDescriptionScreen.dart';
import 'package:health_ed_flutter/features/home/model/response/ResAllQuestion.dart';

import '../../../core/utils/custom_widgets.dart';
import 'DragDropScreen.dart';

class LearingVideoDescriptionScreen extends StatefulWidget {
      final ResAllQuestion resAllQuestion;
const LearingVideoDescriptionScreen({Key? key, required this.resAllQuestion}) : super(key: key);
  @override
  _VideoDescriptionScreenState createState() =>
      _VideoDescriptionScreenState();
}


class _VideoDescriptionScreenState extends State<LearingVideoDescriptionScreen> {
    String selectedLanguage = 'English';
  bool isDragging = false;
   String languageCode = "en-US";
  late Learnings1 instruction2;
  final TextToSpeech _tts = TextToSpeech();

  @override
  void initState() {
    super.initState();
      instruction2 = widget.resAllQuestion.data!.activity!.pictureExpressions!.learnings!.first;
    }
  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  List<bool> selectedCards = [];

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
              image: AssetImage('assets/bg/videobg.png'),
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
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Image with full width and fixed height
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
                SizedBox(height: 30),
                 Spacer(),
                   Container(
                     margin: EdgeInsets.symmetric(horizontal: 20),
                     child: CustomGradientButton(
                       label: 'Done Watching?',
                       onTap: () {
                        if(widget.resAllQuestion.data!.activity!.pictureExpressions!.learnings!.length>0){
                           Get.to(() => VideoDescriptionScreen(resAllQuestion: widget.resAllQuestion,));
                         }else if(widget.resAllQuestion.data!.activity!.pictureExpressions!.learnings!.length>0){
                           Get.to(() => DragDropScreen(resAllQuestion: widget.resAllQuestion,));
                         }
                       },
                     ),
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

  Widget _buildOptionCard(String text, bool isCorrect, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCards[index] = true;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // Only show red/green when clicked
        color: selectedCards[index] 
            ? (isCorrect ? Colors.green : Colors.red)
            : Colors.white.withOpacity(0.9),
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: selectedCards[index] ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (selectedCards[index])
              Positioned(
                right: 4,
                top: 3,
                child: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 24,
                ),
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
                       Get.to(() => LearingVideoDescriptionScreen(resAllQuestion: widget.resAllQuestion,));
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

}
