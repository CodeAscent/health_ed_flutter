import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/model/response/ResAllQuestion.dart';

class MediaSlider extends StatefulWidget {
  final List<Media> mediaList;
  MediaSlider({required this.mediaList});
  @override
  _MediaSliderState createState() => _MediaSliderState();
}

class _MediaSliderState extends State<MediaSlider> {
  int currentIndex = 0;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, AudioPlayer> _audioPlayers = {};

  @override
  void dispose() {
    // Dispose all controllers
    _videoControllers.forEach((_, controller) => controller.dispose());
    _audioPlayers.forEach((_, player) => player.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void _pausePreviousMedia(int index) {
    // Pause previous video
    if (_videoControllers[index]?.value.isPlaying == true) {
      _videoControllers[index]?.pause();
    }

    // Pause previous audio
    if (_audioPlayers[index]?.playing == true) {
      _audioPlayers[index]?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                // Apply border radius
              ),
              child: ClipRRect(
                // Ensure radius applies to content
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _pausePreviousMedia(currentIndex); // Pause previous media
                      currentIndex = index;
                    });
                  },
                  itemCount: widget.mediaList.length,
                  itemBuilder: (context, index) {
                    final mediaPath = widget.mediaList[index].url;
                    // debugPrint("Media List: ${widget.mediaList[index].type}");
                    if (mediaPath != null &&
                        widget.mediaList[index].type == "video") {
                      return _buildVideoPlayer(index, mediaPath);
                    } else if (mediaPath != null &&
                        widget.mediaList[index].type == "audio") {
                      return _buildAudioPlayer(index, mediaPath);
                    } else {
                      return Image.network(
                        mediaPath ?? '',
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.mediaList.length, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: currentIndex == index ? 12.0 : 8.0,
                height: currentIndex == index ? 12.0 : 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? ColorPallete.secondary
                      : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(int index, String videoPath) {
    VideoPlayerController? controller = _videoControllers[index];

    if (controller == null) {
      controller = VideoPlayerController.network(videoPath)
        ..initialize().then((_) {
          if (mounted) setState(() {});
        })
        ..addListener(() {
          if (controller!.value.position == controller.value.duration) {
            controller.seekTo(Duration.zero);
            controller.play();
          }
        });
      _videoControllers[index] = controller;
    }

    return GestureDetector(
      onTap: () {
        if (controller!.value.isInitialized) {
          setState(() {
            if (controller!.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          });
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (controller.value.isInitialized)
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            )
          else
            Center(child: CircularProgressIndicator()),
          if (!controller.value.isPlaying)
            Icon(
              Icons.play_arrow,
              size: 80,
              color: Colors.white.withOpacity(0.8),
            ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(int index, String audioPath) {
    AudioPlayer? player = _audioPlayers[index];

    if (player == null) {
      player = AudioPlayer();
      _audioPlayers[index] = player;
    }

    return GestureDetector(
      onTap: () async {
        if (player!.playing) {
          await player.pause();
        } else {
          _pausePreviousMedia(currentIndex);
          await player.setUrl(audioPath);
          await player.play();
        }
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/icons/audioicon1.png',
              width: 200,
            ),
          ),
          // if (player.playing)
          //   Positioned(
          //     child: Icon(
          //       Icons.pause_circle_filled,
          //       size: 50,
          //       color: ColorPallete.primary,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
