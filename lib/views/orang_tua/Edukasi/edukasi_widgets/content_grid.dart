import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/artikel_detail_view.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_view.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/edukasi_card.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/video_detail_view.dart';

Widget buildContentGrid(EdukasiViewModel viewModel) {
  final items = viewModel.getFilteredItems();

  return items.isEmpty
      ? SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Tidak ada konten ditemukan',
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
            ],
          ),
        ),
      )
      : SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => EdukasiCard(
            item: items[index],
            onTap: () => _navigateToDetail(context, items[index]),
          ),
          childCount: items.length,
        ),
      );
}

void _navigateToDetail(BuildContext context, dynamic item) {
  if (item is ArtikelEdukasi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtikelDetailView(artikel: item),
      ),
    );
  } else if (item is VideoEdukasi) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoDetailView(video: item)),
    );
  }
}
