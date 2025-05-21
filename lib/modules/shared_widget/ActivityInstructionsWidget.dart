import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/custom_widgets.dart';
import 'package:health_ed_flutter/core/utils/helper.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:html/parser.dart';

class ActivityInstructionsWidget extends StatefulWidget {
  final Instruction instructions;
  final VoidCallback onContinue;

  const ActivityInstructionsWidget({
    Key? key,
    required this.instructions,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<ActivityInstructionsWidget> createState() =>
      _ActivityInstructionsWidgetState();
}

class _ActivityInstructionsWidgetState
    extends State<ActivityInstructionsWidget> {
  String languageCode = "en-US";
  String selectedLanguage = 'English';
  final TextToSpeech _tts = TextToSpeech();

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  void deactivate() {
    _tts.stop();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final instructionHtml = _getInstructionHtml(widget.instructions);

    return SafeArea(
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
              children: [
                CustomTransparentContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
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
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _tts.speak(
                                parse(instructionHtml).documentElement!.text,
                                languageCode: languageCode,
                              );
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
                        child: SingleChildScrollView(
                          child: HtmlWidget(
                            instructionHtml,
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: ColorPallete.greyColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomGradientButton(
                        label: 'Done',
                        onTap: () {
                          _tts.stop();
                          widget.onContinue();
                        },
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

  String _getInstructionHtml(Instruction instructions) {
    switch (getLanguageCode(selectedLanguage, languageCode)) {
      case 'hi':
        return instructions.body?['hi'] ?? "Instructions not available";
      case 'or':
        return instructions.body?['or'] ?? "Instructions not available";
      default:
        return instructions.body?['en'] ?? "Instructions not available";
    }
  }
}
