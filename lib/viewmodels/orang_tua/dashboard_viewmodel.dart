import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/edukasi_item.dart';
import 'package:molita_flutter/models/orang_tua/informasi_kesehatan_model.dart';

class DashboardViewModel with ChangeNotifier {
  final String username = "Bunda Ayu";

  final List<Anak> _children = [

  ];

  final List<EdukasiItem> _educationItems = [

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
