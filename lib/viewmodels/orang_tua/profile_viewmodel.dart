import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/OrangTuaService.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel with ChangeNotifier {
  OrangTua? _orangTua;
  bool _isLoading = false;

  OrangTua? get orangTua => _orangTua;
  bool get isLoading => _isLoading;

  void setOrangTua(OrangTua orangTua) {
    _orangTua = orangTua;
    notifyListeners();
  }

  Future<void> updateProfileData(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await OrangTuaService().updateProfile(id, data);
      _orangTua = updated;
      loadOrangTua(id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadNewPhoto(String id, String imagePath) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newImageUrl = await OrangTuaService().uploadPhoto(id, imagePath);
      if (_orangTua != null) {
        _orangTua = OrangTua(
          idOrangTua: _orangTua!.idOrangTua,
          namaIbu: _orangTua!.namaIbu,
          namaAyah: _orangTua!.namaAyah,
          nikIbu: _orangTua!.nikIbu,
          nikAyah: _orangTua!.nikAyah,
          alamat: _orangTua!.alamat,
          noTelepon: _orangTua!.noTelepon,
          email: _orangTua!.email,
          username: _orangTua!.username,
          img: newImageUrl,
        );
      }
      loadOrangTua(id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrangTua(String? id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final orangTuaData = await OrangTuaService().fetchOrangTua(id!);
      _orangTua = orangTuaData;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data yang tersimpan
    _orangTua = null;
    notifyListeners();
  }
}
