import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailScreen extends StatefulWidget {
  final VideoEdukasi video;

  const VideoDetailScreen({Key? key, required this.video}) : super(key: key);

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();

    // Ambil videoId dari URL YouTube
    final videoId = YoutubePlayer.convertUrlToId(widget.video.urlVideo) ?? '';

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false, // Matikan autoplay
        mute: false,
        enableCaption: true,
        isLive: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () {
          // Optional: You can do something when player is ready
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.video.jenisEdukasi.judul)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player, // YoutubePlayer widget
                const SizedBox(height: 16),
                Text(
                  widget.video.deskripsi,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
