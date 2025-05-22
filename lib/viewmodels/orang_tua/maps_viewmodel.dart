import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/JenisPosyanduService.dart';
import 'package:molita_flutter/core/services/OrangTuaService.dart';
import 'package:molita_flutter/models/orang_tua/jenis_posyandu_model.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  OrangTua? _orangTua;
  JenisPosyandu? _jenisPosyandu;

  final OrangTuaService _service = OrangTuaService();
  final JenisPosyanduService _jenisPosyanduService = JenisPosyanduService();

  OrangTua? get orangTua => _orangTua;
  JenisPosyandu? get jenisPosyandu => _jenisPosyandu;

  MapsViewModel() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final idOrangTua = prefs.getString('id_orang_tua');

    if (idOrangTua != null) {
      _orangTua = await _service.fetchOrangTua(idOrangTua);

      final idJenisPosyandu = _orangTua?.idJenisPosyandu;
      if (idJenisPosyandu != null) {
        await fetchJenisPosyandu(idJenisPosyandu);
      }
    }
    notifyListeners();
  }

  Future<void> fetchJenisPosyandu(String id) async {
    try {
      final data = await _jenisPosyanduService.getById(id);
      _jenisPosyandu = JenisPosyandu.fromJson(data);
      notifyListeners();
    } catch (e) {
      print('Error fetching jenis posyandu: $e');
    }
  }
}
