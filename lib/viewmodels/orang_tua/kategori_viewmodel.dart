import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'dart:convert';
import '../../models/orang_tua/kategori_pengaduan_model.dart';

class KategoriViewModel with ChangeNotifier {
  List<KategoriPengaduan> kategoriList = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchKategori() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('${AppConstant.baseUrlApi}/kategori-pengaduan');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        kategoriList = List<KategoriPengaduan>.from(
          data['data'].map((item) => KategoriPengaduan.fromJson(item)),
        );
      } else {
        error = 'Gagal mengambil data';
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
