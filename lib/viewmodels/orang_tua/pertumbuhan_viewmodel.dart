import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/PertumbuhanService.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/pertumbuhan_model.dart';

class PertumbuhanViewModel extends ChangeNotifier {
  final PertumbuhanService _service = PertumbuhanService();

  List<Anak> _daftarAnak = [];
  List<Pertumbuhan> _dataPertumbuhan = [];
  Anak? _selectedAnak;
  String _selectedGrafik = 'Semua';
  bool _isLoading = false;

  List<Anak> get daftarAnak => _daftarAnak;
  List<Pertumbuhan> get dataPertumbuhan => _dataPertumbuhan;
  Anak? get selectedAnak => _selectedAnak;
  String get selectedGrafik => _selectedGrafik;
  bool get isLoading => _isLoading;

  void setSelectedAnak(Anak anak) {
    _selectedAnak = anak;
    notifyListeners();
    _loadPertumbuhanData(anak.id);
  }

  void setSelectedGrafik(String jenis) {
    _selectedGrafik = jenis;
    notifyListeners();
  }

  Future<void> init(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _daftarAnak = await _service.getAnakList(userId);
      if (_daftarAnak.isNotEmpty) {
        _selectedAnak = _daftarAnak[0];
        await _loadPertumbuhanData(_selectedAnak!.id);
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadPertumbuhanData(String idAnak) async {
    try {
      _dataPertumbuhan = await _service.getPertumbuhanData(idAnak);
      _dataPertumbuhan.sort(
        (a, b) => a.tanggalPencatatan.compareTo(b.tanggalPencatatan),
      );
    } catch (e) {
      print("Error: $e");
    }
    notifyListeners();
  }
}
