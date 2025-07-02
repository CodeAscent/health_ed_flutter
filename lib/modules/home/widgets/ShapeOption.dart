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
      height: 105,
      width: 105,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
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
    Key? key,
  }) : super(key: key);

  @override
  State<AudioOption> createState() => _AudioOptionState();
}

class _AudioOptionState extends State<AudioOption>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;
  late final AnimationController _animationController;
  late final Animation<double> _borderWidthAnimation;
  late final Animation<Color?> _borderColorAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _borderWidthAnimation = Tween<double>(begin: 1.0, end: 3.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _borderColorAnimation = ColorTween(
      begin: Colors.green.withOpacity(0.5),
      end: Colors.green,
    ).animate(_animationController);

    _animationController.stop();

    // Pre-load the audio when widget initializes
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      // Set the URL and pre-load the audio
      await _audioPlayer.setUrl(widget.audio, preload: true);
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }

    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed ||
          playerState.processingState == ProcessingState.idle) {
        _animationController.stop();
      } else if (playerState.playing) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> toggleAudio() async {
    try {
      if (!_isInitialized) {
        await _initializeAudio();
        if (!_isInitialized) return;
      }

      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        if (_audioPlayer.processingState == ProcessingState.completed) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error toggling audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentlyPlaying = _audioPlayer.playing &&
        _audioPlayer.processingState != ProcessingState.completed;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          height: 110,
          width: 110,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isCurrentlyPlaying
                  ? _borderColorAnimation.value!
                  : widget.isHighlighted
                      ? ColorPallete.primary
                      : widget.isMatched
                          ? Colors.green
                          : Colors.transparent,
              width: isCurrentlyPlaying ? _borderWidthAnimation.value : 1.0,
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
                        child: _isInitialized
                            ? Image.asset(
                                'assets/icons/bluesound.png',
                                fit: BoxFit.contain,
                                width: 60,
                                height: 60,
                                opacity: AlwaysStoppedAnimation(
                                    widget.originalImageOpacity),
                              )
                            : const CircularProgressIndicator(),
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
      },
    );
  }
}
