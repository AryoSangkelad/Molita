import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/artikel_detail_widgets/meta_chip.dart';

Widget buildArticleMeta(ThemeData theme, ArtikelEdukasi artikel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          artikel.judul,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.3,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            buildMetaChip(
              icon: Icons.category_rounded,
              label: artikel.jenisEdukasi.judul,
            ),
          ],
        ),
      ],
    );
  }