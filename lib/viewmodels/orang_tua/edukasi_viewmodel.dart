// lib/viewmodels/edukasi_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/EdukasiService.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/models/orang_tua/jenis_edukasi.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';

class EdukasiViewModel with ChangeNotifier {
  final EdukasiService _service = EdukasiService();
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

  Future<void> loadData() async {
    _categories = await _service.getJenisEdukasi();
    _artikels = await _service.getArtikel();
    _videos = await _service.getVideo();
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
