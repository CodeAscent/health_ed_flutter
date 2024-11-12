import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/features/navigation/views/screens/MainScreen.dart';

import '../../../../core/tts/text_to_speech.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/utils/custom_widgets.dart';
import '../../../../core/utils/helper.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/intro/slider_bloc.dart';
import '../../models/response/AssessmentQuestionResponse.dart';
import '../../widgets/congrats_popup.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int selectedOption = 0;
  int currentQuestionIndex = 0;
  List<Questions> questionData = [];
  String languageCode = "en-US";
  String selectedLanguage = 'English';
  final TextToSpeech _tts = TextToSpeech();


  @override
  void initState() {
    super.initState();
    // Trigger the event to fetch assessment questions
    context.read<AuthBloc>().add(AuthAssessmentQuestionDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          customSnackbar(state.message, ContentType.failure);
        }
      },
      builder: (context, state) {
        if (state is AuthAssessmentQuestionSuccess) {
           questionData = state.assessmentQuestionResponse.data!.questions ?? [];

          if (questionData.isEmpty) {
            return Center(child: Text("No questions available."));
          }

          var currentQuestion = questionData[currentQuestionIndex];

           String? questionText;
           switch (selectedLanguage) {
             case "English":
               questionText = currentQuestion.questionText?.en;
               break;
             case "Hindi":
               questionText = currentQuestion.questionText?.hi;
               break;
             case "Odia":
               questionText = currentQuestion.questionText?.or;
               break;
             default:
               questionText = "No Question Text";
           }          var options = currentQuestion.options ?? [];

          return Scaffold(
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/bg/questionBg.png'),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTransparentContainer(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                AppBackButton(),
                                SizedBox(width: 6),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: LinearProgressIndicator(
                                      minHeight: 8,
                                      value: (currentQuestionIndex + 1) / questionData.length,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(ColorPallete.primary),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "${currentQuestionIndex + 1}/${questionData.length}",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (){    _tts.speak(questionText!, languageCode: languageCode);},
                                  child:Image.asset('assets/icons/volume_up.png', width: 24, height: 24),),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    questionText!,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6), // Background color
                                    borderRadius: BorderRadius.circular(5), // Rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(0, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _showCupertinoDropdown(context),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                            SizedBox(height: 20),
                            Column(
                              children: List.generate(
                                options.length,
                                    (index) {
                                  // Determine option text based on the selected language
                                  String optionText;
                                  switch (selectedLanguage) {
                                    case "English":
                                      optionText = options[index].en ?? '';
                                      break;
                                    case "Hindi":
                                      optionText = options[index].hi ?? '';
                                      break;
                                    case "Odia":
                                      optionText = options[index].or ?? '';
                                      break;
                                    default:
                                      optionText = "No Option Text";
                                  }
                                  return buildOptionTile(
                                    "${getRomanNumeral(index)}. $optionText",
                                    index + 1,
                                  );
                                },
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: currentQuestionIndex > 0
                                          ? () {
                                        setState(() {
                                          currentQuestionIndex--;
                                          selectedOption = 0; // Reset selection for new question
                                        });
                                      }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: BorderSide(color: ColorPallete.primary),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.arrow_back_ios_new_rounded, color: ColorPallete.primary),
                                          SizedBox(width: 5),
                                          Text(
                                            "Previous",
                                            style: TextStyle(color: ColorPallete.primary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: currentQuestionIndex < questionData.length - 1
                                          ? () {
                                        setState((){
                                          currentQuestionIndex++;
                                          selectedOption = 0; // Reset selection for new question
                                        });
                                      }
                                      : () {
                                        Get.dialog(CongratsPopup(level: '2'));
                                        Future.delayed(Duration(seconds: 3), () {
                                          Get.back();
                                          Get.to(MainScreen());
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: ColorPallete.primary,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Next",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return CustomLoader();
        }
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

  Widget buildOptionTile(String optionText, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          questionData[currentQuestionIndex].selectedOption = value;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: questionData[currentQuestionIndex].selectedOption == value ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 10),
        child: Text(
          optionText,
          style: TextStyle(
            fontSize: 18,
            color: questionData[currentQuestionIndex].selectedOption == value ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }
}

