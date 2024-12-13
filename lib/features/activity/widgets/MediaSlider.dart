import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  final Map<int, VideoPlayerController> _controllers = {};

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [

          Expanded(
            child:
      ClipRRect(
      borderRadius: BorderRadius.circular(20), // Applying the radius here
      child:
            PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  if (widget.mediaList[currentIndex].url?.endsWith('.mp4') == true) {
                    _controllers[currentIndex]?.pause();
                  }
                  currentIndex = index;
                });
              },
              itemCount: widget.mediaList.length,
              itemBuilder: (context, index) {
                final mediaPath = widget.mediaList[index].url;
                if (mediaPath != null && mediaPath.endsWith('.mp4')) {
                  return _buildVideoPlayer(index, mediaPath);
                } else {
                  return Image.network(
                    mediaPath ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  );
                }
              },
            )),
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
                  color: currentIndex == index ? ColorPallete.secondary : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  Widget _buildVideoPlayer(int index, String videoPath) {
    // Declare the controller variable first
    VideoPlayerController? controller = _controllers[index];

    // Check if the controller is not already initialized
    if (controller == null) {
      controller = VideoPlayerController.network(videoPath)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        })
        ..addListener(() {
          // Check if the video has finished playing
          if (controller!.value.position == controller.value.duration) {
            controller.seekTo(Duration.zero);
            controller.play();
          }
        });
      _controllers[index] = controller;
    }

    // Now the controller is guaranteed to be initialized before use
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),

          // Show play/pause icon when video is paused
          if (!controller.value.isPlaying)
            Positioned(
              child: AnimatedOpacity(
                opacity: controller.value.isPlaying ? 0.0 : 1.0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  Icons.play_arrow,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),

          // Show pause icon when video is playing
          if (controller.value.isPlaying)
            Positioned(
              child: AnimatedOpacity(
                opacity: controller.value.isPlaying ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  Icons.pause,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }




}
