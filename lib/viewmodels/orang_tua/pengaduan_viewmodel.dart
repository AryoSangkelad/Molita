import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/pengaduan_model.dart';
import 'package:http/http.dart' as http;

class PengaduanViewModel with ChangeNotifier {
  List<Pengaduan> pengaduanList = [];
  bool isLoading = false;
  String? error;

  /// Fetch semua pengaduan untuk orang tua tertentu
  Future<void> fetchPengaduanList({required String idOrangTua}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final url = Uri.parse(
        '${AppConstant.baseUrlApi}/pengaduan?id_orang_tua=$idOrangTua',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'] as List<dynamic>;

        pengaduanList = data.map((item) => Pengaduan.fromJson(item)).toList();
      } else {
        error = 'Gagal memuat data (${response.statusCode})';
      }
    } catch (e) {
      error = 'Terjadi kesalahan: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Submit pengaduan baru
  Future<bool> submitPengaduan(Pengaduan pengaduan, {File? lampiran}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchPengaduanList(idOrangTua: pengaduan.idOrangTua);
        return true;
      } else {
        error = 'Gagal mengirim pengaduan (${response.statusCode})';
        return false;
      }
    } catch (e) {
      error = 'Terjadi kesalahan saat mengirim: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
