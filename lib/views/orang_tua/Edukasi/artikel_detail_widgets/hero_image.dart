import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';

Widget buildHeroImage(ArtikelEdukasi artikel) {
    return Hero(
      tag: artikel.idArtikel,
      child: Image.network(
        '${AppConstant.baseUrlFoto}${artikel.thumbnail}',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(
                  Icons.article_rounded,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
      ),
    );
  }