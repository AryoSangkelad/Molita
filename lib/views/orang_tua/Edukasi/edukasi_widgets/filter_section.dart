import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_widgets/my_filter_chip.dart';

Widget buildFilterSection(Color primaryColor, EdukasiViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromARGB(255, 228, 228, 228),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            MyFilterChip(
              label: 'Semua',
              icon: Icons.widgets_rounded,
              isSelected: viewModel.selectedType == 'Semua',
              onTap: () => viewModel.setSelectedType('Semua'),
            ),
            MyFilterChip(
              label: 'Video',
              icon: Icons.play_circle_fill_rounded,
              isSelected: viewModel.selectedType == 'video',
              onTap: () => viewModel.setSelectedType('video'),
              color: Colors.red,
            ),
            MyFilterChip(
              label: 'Artikel',
              icon: Icons.article_rounded,
              isSelected: viewModel.selectedType == 'artikel',
              onTap: () => viewModel.setSelectedType('artikel'),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }