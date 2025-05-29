import 'dart:async';
import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/video_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildVideoTerbaru(DashboardViewModel viewModel) {
  return _VideoTerbaruSlider(viewModel: viewModel);
}

class _VideoTerbaruSlider extends StatefulWidget {
  final DashboardViewModel viewModel;

  const _VideoTerbaruSlider({super.key, required this.viewModel});

  @override
  State<_VideoTerbaruSlider> createState() => _VideoTerbaruSliderState();
}

class _VideoTerbaruSliderState extends State<_VideoTerbaruSlider> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final videoList = widget.viewModel.getVideoOnly();
      if (_controller.hasClients && videoList.isNotEmpty) {
        int nextPage = (_currentPage + 1) % videoList.length;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tidak bisa membuka link: $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoList = widget.viewModel.getVideoOnly();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Video Terbaru",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        if (videoList.isEmpty)
          const Center(child: Text("Belum ada video."))
        else
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.26,
            child: PageView.builder(
              controller: _controller,
              itemCount: videoList.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final info = videoList[index];
                final isActive = index == _currentPage;
                print(info);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: isActive ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              getThumbnailUrl(info.thumbnail, info.urlVideo),
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.broken_image),
                                    ),
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                info.jenisEdukasi.judul,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.grey,
                                  size: 48,
                                ),
                                onPressed: () {
                                  if (info.urlVideo.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                VideoDetailScreen(video: info),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          info.judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Baru", // Tambahkan tanggal jika tersedia
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

String getThumbnailUrl(String thumbnail, String? urlVideo) {
  final isDefault = thumbnail == 'edukasi/default.png';

  // Cek apakah URL video valid dan ambil YouTube ID
  String? youtubeId;
  if (urlVideo != null && urlVideo.isNotEmpty) {
    final regExp = RegExp(r'(?:v=|youtu\.be/|embed/)([a-zA-Z0-9_-]+)');
    final match = regExp.firstMatch(urlVideo);
    if (match != null) {
      youtubeId = match.group(1);
    }
  }

  // Gunakan thumbnail YouTube jika default
  if (isDefault && youtubeId != null) {
    return 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
  }

  // Jika sudah URL
  if (Uri.tryParse(thumbnail)?.hasAbsolutePath == true) {
    return thumbnail;
  }

  // Thumbnail biasa dari server
  return '${AppConstant.baseUrlFoto}$thumbnail';
}
