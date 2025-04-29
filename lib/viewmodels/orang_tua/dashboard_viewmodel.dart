import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/edukasi_item_model.dart';
import 'package:molita_flutter/models/orang_tua/informasi_kesehatan_model.dart';

class DashboardViewModel with ChangeNotifier {
  final String username = "Bunda Ayu";

  final List<Anak> _children = [
    Anak(
      nama: "Rizky Ramadhan",
      tanggalLahir: "15 Januari 2020",
      imunisasi: "Lengkap",
      beratBadan: 14.5,
      tinggiBadan: 98.0,
      lingkarKepala: 49.0,
    ),
    Anak(
      nama: "Naura Putri",
      tanggalLahir: "8 Mei 2018",
      imunisasi: "DTP 3",
      beratBadan: 12.7,
      tinggiBadan: 89.0,
      lingkarKepala: 47.5,
    ),
  ];

  final List<EdukasiItem> _educationItems = [
    EdukasiItem(
      judul: "Pertumbuhan Bayi Usia 0-6 Bulan",
      deskripsi: "Penjelasan lengkap tentang perkembangan fisik...",
      urlGambar: "https://picsum.photos/id/1/200/300",
    ),
    EdukasiItem(
      judul: "Nutrisi Penting untuk Balita",
      deskripsi: "Rekomendasi menu seimbang untuk mendukung...",
      urlGambar: "https://picsum.photos/id/2/200/300",
    ),
    EdukasiItem(
      judul: "Stimulasi Perkembangan Otak",
      deskripsi: "Permainan edukatif untuk meningkatkan...",
      urlGambar: "https://picsum.photos/id/3/200/300",
    ),
  ];

  final List<InformasiKesehatan> _healthInfos = [
    InformasiKesehatan(
      judul: "Vaksin MR Tersedia",
      urlGambar: "https://picsum.photos/id/4/200/300",
    ),
    InformasiKesehatan(
      judul: "Program Imunisasi Nasional",
      urlGambar: "https://picsum.photos/id/5/200/300",
    ),
  ];

  List<Anak> get children => _children;
  List<EdukasiItem> get educationItems => _educationItems;
  List<InformasiKesehatan> get healthInformations => _healthInfos;
}
