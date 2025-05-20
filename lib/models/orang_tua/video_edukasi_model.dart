import 'package:molita_flutter/models/orang_tua/jenis_edukasi.dart';

class VideoEdukasi {
  final String idVideo;
  final String idJenisEdukasi;
  final String judul;
  final String deskripsi;
  final String thumbnail;
  final String urlVideo;
  final String slug;
  final JenisEdukasi jenisEdukasi;

  VideoEdukasi({
    required this.idVideo,
    required this.idJenisEdukasi,
    required this.judul,
    required this.deskripsi,
    required this.thumbnail,
    required this.urlVideo,
    required this.slug,
    required this.jenisEdukasi,
  });

  factory VideoEdukasi.fromJson(Map<String, dynamic> json) {
    return VideoEdukasi(
      idVideo: json['id_video'],
      idJenisEdukasi: json['id_jenis_edukasi'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      thumbnail: json['thumbnail'],
      urlVideo: json['url_video'],
      slug: json['slug'],
      jenisEdukasi: JenisEdukasi.fromJson(json['jenis_edukasi']),
    );
  }
}
