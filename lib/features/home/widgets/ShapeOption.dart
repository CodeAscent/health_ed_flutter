
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
      height: 110,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted
              ? ColorPallete.primary
              : isMatched
              ? Colors.green
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                shape,
                fit: BoxFit.contain,
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
                  return Icon(Icons.error);
                },
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
      // Stop any other playing audio first
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
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isHighlighted
              ? ColorPallete.primary
              : widget.isMatched
              ? Colors.green
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: toggleAudio,
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    'assets/icons/audioicon.png',
                    height: 30,
                    width: 30,
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
      ),
    );
  }
}


