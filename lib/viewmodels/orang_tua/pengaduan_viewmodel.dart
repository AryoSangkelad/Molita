import 'dart:io';
import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/PengaduanService.dart';
import 'package:molita_flutter/models/orang_tua/pengaduan_model.dart';

class PengaduanViewModel with ChangeNotifier {
  final PengaduanService _service = PengaduanService();

  List<Pengaduan> pengaduanList = [];
  bool isLoading = false;
  String? error;

  /// Fetch semua pengaduan
  Future<void> fetchPengaduanList({required String idOrangTua}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      pengaduanList = await _service.fetchPengaduanList(idOrangTua);
    } catch (e) {
      error = e.toString();
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
      await _service.submitPengaduan(pengaduan, lampiran: lampiran);
      await fetchPengaduanList(idOrangTua: pengaduan.idOrangTua);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
