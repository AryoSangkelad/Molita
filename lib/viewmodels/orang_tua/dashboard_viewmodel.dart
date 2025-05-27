import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/AnakService.dart';
import 'package:molita_flutter/core/services/EdukasiService.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/models/orang_tua/edukasi_item.dart';
import 'package:molita_flutter/models/orang_tua/informasi_kesehatan_model.dart';
import 'package:molita_flutter/models/orang_tua/jenis_edukasi.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';

class DashboardViewModel with ChangeNotifier {
  final String username = "Bunda Ayu";

  List<Anak> _daftarAnak = [];
  final List<EdukasiItem> _educationItems = [];

  AnakService _service = AnakService();

  List<Anak> get daftarAnak => _daftarAnak;

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

  List<EdukasiItem> get educationItems => _educationItems;
  List<InformasiKesehatan> get healthInformations => _healthInfos;

  Future<void> loadData(String idOrangTua) async {
    _daftarAnak = await _service.getAllByOrangTua(idOrangTua);
    _categories = await _edukasiService.getJenisEdukasi();
    _artikels = await _edukasiService.getArtikel();
    _videos = await _edukasiService.getVideo();
    notifyListeners();
  }

  List<Anak> getAllAnakByOrangTua() {
    return _daftarAnak;
  }

  final EdukasiService _edukasiService = EdukasiService();
  List<JenisEdukasi> _categories = [];
  List<ArtikelEdukasi> _artikels = [];
  List<VideoEdukasi> _videos = [];
  String _selectedCategory = 'Semua';
  String _selectedType = 'Semua';

  List<JenisEdukasi> get categories => _categories;
  List<ArtikelEdukasi> get artikels => _artikels;
  List<VideoEdukasi> get videos => _videos;
  String get selectedCategory => _selectedCategory;
  String get selectedType => _selectedType;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  List<dynamic> getFilteredItems() {
    List<dynamic> allItems = [..._artikels, ..._videos];

    if (_selectedCategory != 'Semua') {
      allItems =
          allItems.where((item) {
            if (item is ArtikelEdukasi) {
              return item.jenisEdukasi.judul == _selectedCategory;
            } else if (item is VideoEdukasi) {
              return item.jenisEdukasi.judul == _selectedCategory;
            }
            return false;
          }).toList();
    }

    if (_selectedType != 'Semua') {
      allItems =
          allItems.where((item) {
            if (item is ArtikelEdukasi && _selectedType == 'artikel')
              return true;
            if (item is VideoEdukasi && _selectedType == 'video') return true;
            return false;
          }).toList();
    }

    return allItems;
  }

  List<ArtikelEdukasi> getArtikelOnly() {
    if (_selectedCategory == 'Semua') {
      return _artikels;
    }
    return _artikels
        .where((artikel) => artikel.jenisEdukasi.judul == _selectedCategory)
        .toList();
  }

  List<VideoEdukasi> getVideoOnly() {
    if (_selectedCategory == 'Semua') {
      return _videos;
    }
    return _videos
        .where((video) => video.jenisEdukasi.judul == _selectedCategory)
        .toList();
  }
}
