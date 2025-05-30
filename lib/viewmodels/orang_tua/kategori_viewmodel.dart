import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/kategoriPengaduanService.dart';
import 'package:molita_flutter/models/orang_tua/kategori_pengaduan_model.dart';

class KategoriViewModel with ChangeNotifier {
  final KategoriPengaduanService _kategoriService = KategoriPengaduanService();

  List<KategoriPengaduan> kategoriList = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchKategori() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      kategoriList = await _kategoriService.fetchKategoriList();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
