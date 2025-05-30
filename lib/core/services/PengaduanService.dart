import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/pengaduan_model.dart';

class PengaduanService {
  /// Fetch semua pengaduan untuk orang tua tertentu
  Future<List<Pengaduan>> fetchPengaduanList(String idOrangTua) async {
    final url = Uri.parse('${AppConstant.baseUrlApi}/pengaduan?id_orang_tua=$idOrangTua');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = jsonData['data'] as List<dynamic>;
      return data.map((item) => Pengaduan.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data (${response.statusCode})');
    }
  }

  /// Submit pengaduan baru
  Future<void> submitPengaduan(Pengaduan pengaduan, {File? lampiran}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstant.baseUrlApi}/pengaduan'),
    );

    request.fields['id_orang_tua'] = pengaduan.idOrangTua;
    request.fields['judul'] = pengaduan.judul;
    request.fields['deskripsi'] = pengaduan.deskripsi;
    request.fields['kategori_id'] = pengaduan.kategoriId.toString();

    if (lampiran != null) {
      request.files.add(
        await http.MultipartFile.fromPath('lampiran', lampiran.path),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (!(response.statusCode == 200 || response.statusCode == 201)) {
      throw Exception('Gagal mengirim pengaduan (${response.statusCode})');
    }
  }
}
