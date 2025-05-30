
  import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

YoutubePlayer buildVideoPlayer(BuildContext context, YoutubePlayerController youtubeController) {
    return YoutubePlayer(
      controller: youtubeController,
      aspectRatio: 16 / 9,
      progressColors: ProgressBarColors(
        playedColor: Theme.of(context).colorScheme.secondary,
        handleColor: Colors.white,
        backgroundColor: Colors.white54,
      ),
      onEnded: (metaData) {
        youtubeController.pause();
      },
    );
  }