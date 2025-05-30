import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/kategori_pengaduan_model.dart';

class KategoriPengaduanService {
  Future<List<KategoriPengaduan>> fetchKategoriList() async {
    final url = Uri.parse('${AppConstant.baseUrlApi}/kategori-pengaduan');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<KategoriPengaduan>.from(
        data['data'].map((item) => KategoriPengaduan.fromJson(item)),
      );
    } else {
      throw Exception('Gagal mengambil data kategori (${response.statusCode})');
    }
  }
}
