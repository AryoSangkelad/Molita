import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/video_detail_widgets/description_section.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/video_detail_widgets/video_info.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/video_detail_widgets/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailView extends StatefulWidget {
  final VideoEdukasi video;

  const VideoDetailView({Key? key, required this.video}) : super(key: key);

  @override
  _VideoDetailViewState createState() => _VideoDetailViewState();
}

class _VideoDetailViewState extends State<VideoDetailView> {
  late YoutubePlayerController _youtubeController;
  bool _isVideoReady = false;
  double _appBarHeight = 100;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.video.urlVideo) ?? '';

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        isLive: false,
      ),
    )..addListener(() {
      if (_youtubeController.value.isReady && !_isVideoReady) {
        setState(() => _isVideoReady = true);
      }
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return YoutubePlayerBuilder(
      player: buildVideoPlayer(context, _youtubeController),
      builder: (context, player) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                collapsedHeight: 70,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      player, // gunakan player dari YoutubePlayerBuilder
                      if (!_isVideoReady)
                        Container(
                          color: Colors.black,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildVideoInfo(textTheme, widget.video.judul),
                      const SizedBox(height: 24),
                      buildDescriptionSection(
                        textTheme,
                        widget.video.deskripsi,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Wrap(
            spacing: 12,
            children: [
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed:
                    () => _youtubeController.seekTo(
                      _youtubeController.value.position -
                          const Duration(seconds: 10),
                    ),
                child: Icon(Icons.replay_10_rounded, color: Colors.grey[800]),
              ),
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed:
                    () =>
                        _youtubeController.value.isPlaying
                            ? _youtubeController.pause()
                            : _youtubeController.play(),
                child: Icon(
                  _youtubeController.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.grey[800],
                ),
              ),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed:
                    () => _youtubeController.seekTo(
                      _youtubeController.value.position +
                          const Duration(seconds: 10),
                    ),
                child: Icon(Icons.forward_10_rounded, color: Colors.grey[800]),
              ),
            ],
          ),
        );
      },
    );
  }
}
