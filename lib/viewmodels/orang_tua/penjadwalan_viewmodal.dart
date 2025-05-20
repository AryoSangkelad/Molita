import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/PenjadwalanService.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_imunisasi.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';

class PenjadwalanViewModal with ChangeNotifier {
  final PenjadwalanService _penjadwalanService = PenjadwalanService();

  // State untuk jenis jadwal
  String _selectedScheduleType = 'imunisasi';
  final List<String> _scheduleTypes = ['imunisasi', 'posyandu'];
  List<Anak> _daftarAnak = [];

  // State untuk anak
  Anak? _selectedAnak;

  // Data jadwal
  List<JadwalImunisasi> _jadwalImunisasi = [];
  List<JadwalPosyandu> _jadwalPosyandu = [];

  // Detail jadwal yang dipilih
  dynamic _selectedItem;

  // Loading state
  bool _isLoading = false;

  // Getters
  String get selectedScheduleType => _selectedScheduleType;
  List<String> get scheduleTypes => _scheduleTypes;
  Anak? get selectedAnak => _selectedAnak;
  List<Anak> get daftarAnak => _daftarAnak;
  List<JadwalImunisasi> get jadwalImunisasi => _jadwalImunisasi;
  List<JadwalPosyandu> get jadwalPosyandu => _jadwalPosyandu;
  dynamic get selectedItem => _selectedItem;
  bool get isLoading => _isLoading;

  Future<void> init(String idOrangTua) async {
    _isLoading = true;
    notifyListeners();

    try {
      _daftarAnak = await _penjadwalanService.getAnakList(idOrangTua);
      if (_daftarAnak.isNotEmpty) {
        _selectedAnak = _daftarAnak[0];
        final jadwal = await _penjadwalanService.getJadwalImunisasi(_selectedAnak!.id);
        _jadwalImunisasi = jadwal;
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Setters
  void setSelectedScheduleType(String type, String idJenisPosyandu) {
    _selectedScheduleType = type;
    notifyListeners();

    // Muat data awal
    if (type == 'imunisasi' && _selectedAnak != null) {
      fetchJadwalImunisasi(_selectedAnak!.id);
    } else if (type == 'posyandu') {
      fetchJadwalPosyandu(idJenisPosyandu);
    }
  }

  void setSelectedAnak(Anak anak) {
    _selectedAnak = anak;
    notifyListeners();
    fetchJadwalImunisasi(anak.id);
  }

  void setSelectedItem(dynamic item) {
    _selectedItem = item;
    notifyListeners();
  }

  // Fungsi untuk memuat data
  Future<void> fetchJadwalImunisasi(String idAnak) async {
    _isLoading = true;
    notifyListeners();

    try {
      final jadwal = await _penjadwalanService.getJadwalImunisasi(idAnak);
      _jadwalImunisasi = jadwal;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchJadwalPosyandu(String idJenis) async {
    _isLoading = true;
    notifyListeners();

    try {
      final jadwal = await _penjadwalanService.getJadwalPosyandu(idJenis);
      _jadwalPosyandu = jadwal;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
