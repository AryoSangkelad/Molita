import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';

class ArtikelDetailScreen extends StatelessWidget {
  final ArtikelEdukasi artikel;

  const ArtikelDetailScreen({Key? key, required this.artikel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5, // lebih halus dari 1
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          artikel.jenisEdukasi.judul,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                '${ApiConstant.baseUrl}storage/${artikel.thumbnail}',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),

            // Judul
            Text(
              artikel.judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // HTML Konten
            Html(
              data: artikel.konten,
              style: {
                "body": Style(
                  fontSize: FontSize(16),
                  lineHeight: LineHeight(1.6),
                  color: Colors.grey[800],
                ),
                "h1": Style(
                  fontSize: FontSize.xxLarge,
                  fontWeight: FontWeight.bold,
                ),
                "h2": Style(
                  fontSize: FontSize.xLarge,
                  fontWeight: FontWeight.bold,
                ),
                "p": Style(margin: Margins.only(bottom: 12)),
              },
            ),
          ],
        ),
      ),
    );
  }
}
