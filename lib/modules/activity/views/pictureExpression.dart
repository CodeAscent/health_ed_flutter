import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_ed_flutter/core/services/acknowledgment_service.dart';
import 'package:health_ed_flutter/core/services/globals.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:health_ed_flutter/core/tts/text_to_speech.dart';
import 'package:health_ed_flutter/core/utils/helper.dart';
import 'package:health_ed_flutter/modules/activity/views/PictureSequencings.dart';
import 'package:health_ed_flutter/modules/activity/views/understanding_instruction.dart';
import 'package:health_ed_flutter/modules/home/model/response/ResAllQuestion.dart';
import 'package:health_ed_flutter/modules/home/views/screens/all_quizzes_screen.dart';
import 'package:health_ed_flutter/modules/shared_widget/activity_congrats_popup.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/utils/custom_widgets.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';
import '../../home/bloc/home_state.dart';
import '../../home/model/request/AcknowledgementRequest.dart';

// All imports remain unchanged
// ... [imports] ...

class PictureExpression extends StatefulWidget {
  final ResAllQuestion resAllQuestion;
  const PictureExpression({Key? key, required this.resAllQuestion})
      : super(key: key);
  @override
  _PictureExpressionState createState() => _PictureExpressionState();
}

class _PictureExpressionState extends State<PictureExpression> {
  String selectedLanguage = 'English';
  String selectedAcknowledgement = 'Acknowledgement';
  bool isDragging = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String languageCode = "en-US";
  late Learnings1 learnings1;
  final TextToSpeech _tts = TextToSpeech();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    learnings1 = widget
        .resAllQuestion.data!.activity!.pictureExpressions!.learnings!.first;
  }

  @override
  void dispose() {
    _tts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  void _playMatchSound({required bool success}) {
    final asset = success ? 'assets/bg/awsm.mp3' : 'assets/bg/sad.mp3';
    toggleAudio(asset);
  }

  void toggleAudio(String url) async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    }
    await audioPlayer.stop();
    await audioPlayer.setAsset(url);
    await audioPlayer.play();
  }

  List<bool> selectedCards = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetSubmitAcknowledgeResponseFailure) {
          customSnackbar(state.message, ContentType.failure);
        }
      },
      builder: (context, state) {
        String titleData;
        switch (getLanguageCode(selectedLanguage, languageCode)) {
          case 'hi':
            titleData = learnings1.title!.hi ?? "Instructions not available";
            break;
          case 'or':
            titleData = learnings1.title!.or ?? "Instructions not available";
            break;
          default:
            titleData = learnings1.title!.en ?? "Instructions not available";
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isTablet = constraints.maxWidth >= 600;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppBackButton(
                              color: Colors.white,
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
                                                    activityId:
                                                        selectedDayId!));
                                            Get.back();
                                          } else {
                                            Get.off(() => AllQuizzesScreen());
                                          }
                                          Navigator.of(context).pop(true);
                                        },
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
                          ],
                        ),
                        SizedBox(height: 10),
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
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // ✅ Centered image with responsive width
                        Center(
                          child: Center(
                            child: Container(
                              width: isTablet
                                  ? constraints.maxWidth * 0.5
                                  : constraints.maxWidth * 0.9,
                              height: isTablet
                                  ? constraints.maxHeight * 0.4
                                  : constraints.maxHeight * 0.3,
                              child: Image.network(
                                learnings1.media?.url ?? '',
                                fit: BoxFit.fill,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
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
                          ),
                        ),

                        SizedBox(height: 30),

                        // ✅ Option Cards - Responsive Grid
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: isTablet ? 3 : 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            childAspectRatio: 2.5,
                            children: [
                              ...(learnings1.options?.asMap().entries.map(
                                    (entry) {
                                      final index = entry.key;
                                      final option = entry.value;
                                      String optionTitle;
                                      switch (getLanguageCode(
                                          selectedLanguage, languageCode)) {
                                        case 'hi':
                                          optionTitle =
                                              option.option?.hi ?? "NAN";
                                          break;
                                        case 'or':
                                          optionTitle =
                                              option.option?.or ?? "NAN";
                                          break;
                                        default:
                                          optionTitle =
                                              option.option?.en ?? "NAN";
                                      }
                                      if (selectedCards.length <
                                          learnings1.options!.length) {
                                        selectedCards.add(false);
                                      }
                                      return _buildOptionCard(
                                          optionTitle, option.correct!, index);
                                    },
                                  ).toList() ??
                                  []),
                            ],
                          ),
                        ),

                        _buildAcknowledgementButton(context),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(String text, bool isCorrect, int index) {
    return GestureDetector(
      onTap: () {
        _playMatchSound(success: isCorrect);
        setState(() {
          selectedCards[index] = true;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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

  int score = 0;

  Widget _buildAcknowledgementButton(BuildContext context) {
    bool isCompleted = currentIndex ==
        widget.resAllQuestion.data!.activity!.pictureExpressions!.learnings!
                .length -
            1;
    return AcknowledgmentService.buildAcknowledgmentButton(
      context: context,
      selectedAcknowledgement: selectedAcknowledgement,
      secondaryColor: ColorPallete.secondary,
      onNext: () {
        if (isCompleted) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (_) => UnderstandingInstruction(
                key: ValueKey('activity_4'),
                resAllQuestion: widget.resAllQuestion,
                activityNo: 4,
              ),
            ),
          );
        } else {
          currentIndex++;
          selectedAcknowledgement = 'Acknowledgement';
          learnings1 = widget.resAllQuestion.data!.activity!.pictureExpressions!
              .learnings![currentIndex];
          selectedCards.clear();
          setState(() {});
        }
      },
      onAcknowledge: (acknowledgement, score) async {
        setState(() {
          selectedAcknowledgement = acknowledgement;
          this.score = score;
        });
        context.read<HomeBloc>().add(
              SubmitAcknowledgementRequest(
                acknowledgementRequest: AcknowledgementRequest(
                  activity: widget.resAllQuestion.data!.activity!.sId!,
                  acknowledgement: acknowledgement,
                  learning: learnings1.sId!,
                  score: score,
                ),
              ),
            );
      },
    );
  }
}
