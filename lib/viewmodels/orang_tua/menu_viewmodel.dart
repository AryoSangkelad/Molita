import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/JenisPosyanduService.dart';
import 'package:molita_flutter/core/services/OrangTuaService.dart';
import 'package:molita_flutter/core/services/PenjadwalanService.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';
import 'package:molita_flutter/models/orang_tua/jenis_posyandu_model.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:molita_flutter/views/orang_tua/Edukasi/edukasi_view.dart';
import 'package:molita_flutter/views/orang_tua/Grafik/grafik_view.dart';
import 'package:molita_flutter/views/orang_tua/Penjadwalan/penjadwalan_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_view.dart';

class MenuViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  OrangTua? _orangTua;
  List<Widget> _pages = [];
  bool _isLoading = true;
  JenisPosyandu? _jenisPosyandu;

  final JenisPosyanduService _jenisPosyanduService = JenisPosyanduService();
  final OrangTuaService _service = OrangTuaService();
  final PenjadwalanService _PenjadwalanService = PenjadwalanService();

  JadwalPosyandu? _jadwalTerdekat;
  JadwalPosyandu? get jadwalTerdekat => _jadwalTerdekat;

  JenisPosyandu? get jenisPosyandu => _jenisPosyandu;
  int get currentIndex => _currentIndex;
  List<Widget> get pages => _pages;
  OrangTua? get orangTua => _orangTua;
  bool get isLoading => _isLoading;

  MenuViewModel() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final idOrangTua = prefs.getString('id_orang_tua');

    if (idOrangTua != null) {
      _orangTua = await _service.fetchOrangTua(idOrangTua);
    }

    if (_orangTua != null) {
      // Ambil jenis posyandu
      if (_orangTua!.idJenisPosyandu != null) {
        try {
          final data = await _jenisPosyanduService.getById(
            _orangTua!.idJenisPosyandu!,
          );
          _jenisPosyandu = JenisPosyandu.fromJson(data);
        } catch (e) {
          print("❌ Gagal mengambil jenis posyandu: $e");
        }

        try {
          _jadwalTerdekat = await _PenjadwalanService.getJadwalTerdekat(
            _orangTua!.idJenisPosyandu!,
          );
        } catch (e) {
          print("❌ Gagal mengambil jadwal terdekat: $e");
          _jadwalTerdekat = null; // fallback
        }
      }

      _pages = [
        DashboardView(
          orangTua: _orangTua!,
          jenisPosyandu: _jenisPosyandu, // bisa null
          jadwalPosyandu: _jadwalTerdekat, // bisa null
        ),
        PenjadwalanView(
          idOrangTua: _orangTua?.idOrangTua ?? '',
          idjenisPosyandu: _orangTua!.idJenisPosyandu ?? '',
        ),
        EdukasiView(),
        GrafikView(userId: _orangTua!.idOrangTua ?? ''),
        ProfileView(orangTua: _orangTua!),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
