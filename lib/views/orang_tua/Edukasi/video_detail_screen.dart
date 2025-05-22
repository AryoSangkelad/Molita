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
      player: _buildVideoPlayer(),
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
                      _buildVideoInfo(textTheme),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(textTheme),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _buildFloatingControls(),
        );
      },
    );
  }

  YoutubePlayer _buildVideoPlayer() {
    return YoutubePlayer(
      controller: _youtubeController,
      aspectRatio: 16 / 9,
      progressColors: ProgressBarColors(
        playedColor: Theme.of(context).colorScheme.secondary,
        handleColor: Colors.white,
        backgroundColor: Colors.white54,
      ),
      onEnded: (metaData) {
        _youtubeController.pause();
      },
    );
  }

  Widget _buildVideoInfo(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.video.jenisEdukasi.judul,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi Video',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            widget.video.deskripsi,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingControls() {
    return Wrap(
      spacing: 12,
      children: [
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          onPressed:
              () => _youtubeController.seekTo(
                _youtubeController.value.position - const Duration(seconds: 10),
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
                _youtubeController.value.position + const Duration(seconds: 10),
              ),
          child: Icon(Icons.forward_10_rounded, color: Colors.grey[800]),
        ),
      ],
    );
  }
}
