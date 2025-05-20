import 'package:molita_flutter/models/orang_tua/jenis_edukasi.dart';

class ArtikelEdukasi {
  final String idArtikel;
  final String idJenisEdukasi;
  final String judul;
  final String konten;
  final String thumbnail;
  final String slug;
  final JenisEdukasi jenisEdukasi;

  ArtikelEdukasi({
    required this.idArtikel,
    required this.idJenisEdukasi,
    required this.judul,
    required this.konten,
    required this.thumbnail,
    required this.slug,
    required this.jenisEdukasi,
  });

  factory ArtikelEdukasi.fromJson(Map<String, dynamic> json) {
    return ArtikelEdukasi(
      idArtikel: json['id_artikel'],
      idJenisEdukasi: json['id_jenis_edukasi'],
      judul: json['judul'],
      konten: json['konten'],
      thumbnail: json['thumbnail'],
      slug: json['slug'],
      jenisEdukasi: JenisEdukasi.fromJson(json['jenis_edukasi']),
    );
  }
}
