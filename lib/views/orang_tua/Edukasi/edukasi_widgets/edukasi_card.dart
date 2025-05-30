import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/content_overlay.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/thumbnail.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/type_badge.dart';

class EdukasiCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;

  const EdukasiCard({Key? key, required this.item, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isVideo = item is VideoEdukasi;
    String thumbnailUrl = getThumbnailUrl(item, isVideo);
    String title =
        isVideo ? (item as VideoEdukasi).judul : (item as ArtikelEdukasi).judul;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              buildThumbnail(thumbnailUrl),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildContentOverlay(isVideo, title, theme),
              ),
              Positioned(top: 12, right: 12, child: buildTypeBadge(isVideo)),
            ],
          ),
        ),
      ),
    );
  }
}

String getThumbnailUrl(dynamic item, bool isVideo) {
  String thumbnail =
      isVideo
          ? (item as VideoEdukasi).thumbnail
          : (item as ArtikelEdukasi).thumbnail;

  String? urlVideo = isVideo ? (item as VideoEdukasi).urlVideo : null;
  bool isDefault = thumbnail == 'edukasi/default.png';

  // Ambil YouTube ID jika perlu
  String? youtubeId;
  if (isVideo && urlVideo != null && urlVideo.isNotEmpty) {
    final regExp = RegExp(r'(?:v=|youtu\.be/|embed/)([a-zA-Z0-9_-]+)');
    final match = regExp.firstMatch(urlVideo);
    if (match != null) {
      youtubeId = match.group(1);
    }
  }

  // Gunakan thumbnail YouTube jika default dan ID ditemukan
  if (isVideo && isDefault && youtubeId != null) {
    return 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
  }

  // Jika thumbnail sudah URL penuh
  if (Uri.tryParse(thumbnail)?.hasAbsolutePath == true) {
    return thumbnail;
  }

  // Thumbnail lokal dari server
  return '${AppConstant.baseUrlFoto}$thumbnail';
}
