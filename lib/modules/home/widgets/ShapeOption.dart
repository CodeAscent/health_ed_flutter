import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_ed_flutter/core/theme/app_colors.dart';
import 'package:just_audio/just_audio.dart';

class ShapeOption extends StatelessWidget {
  final String shape;
  final bool isHighlighted;
  final bool isMatched;
  final bool showCheck;
  final double originalImageOpacity;

  const ShapeOption({
    required this.shape,
    this.isHighlighted = false,
    this.isMatched = false,
    this.showCheck = false,
    this.originalImageOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        border: Border.all(
          color: isHighlighted
              ? ColorPallete.primary
              : isMatched
                  ? Colors.green
                  : Colors.transparent,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Image as background
          Positioned.fill(
            child: ClipRRect(
              child: Image.network(
                shape,
                fit: BoxFit.cover, // Fill the full container
                opacity: AlwaysStoppedAnimation(originalImageOpacity),
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
                  return Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),
          if (showCheck)
            Positioned(
              top: 2,
              right: 2,
              child: Icon(
                Icons.check_circle,
                color: ColorPallete.primary,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}

class AudioOption extends StatefulWidget {
  final String audio;
  final bool isHighlighted;
  final bool isMatched;
  final bool showCheck;
  final double originalImageOpacity;

  const AudioOption({
    required this.audio,
    this.isHighlighted = false,
    this.isMatched = false,
    this.showCheck = false,
    this.originalImageOpacity = 1.0,
  });

  @override
  State<AudioOption> createState() => _AudioOptionState();
}

class _AudioOptionState extends State<AudioOption> {
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void toggleAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.stop();
      await audioPlayer.setUrl(widget.audio);
      await audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 110,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: widget.isHighlighted
              ? ColorPallete.primary
              : widget.isMatched
                  ? Colors.green
                  : Colors.transparent,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              child: GestureDetector(
                onTap: toggleAudio,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Image.asset(
                      'assets/icons/audioicon.png',
                      fit: BoxFit.contain,
                      width: 40,
                      height: 40,
                      opacity:
                          AlwaysStoppedAnimation(widget.originalImageOpacity),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.showCheck)
            Positioned(
              top: 2,
              right: 2,
              child: Icon(
                Icons.check_circle,
                color: ColorPallete.primary,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
