import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/PertumbuhanService.dart';
import 'package:molita_flutter/core/services/chatbotService.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/pertumbuhan_model.dart';

class PertumbuhanViewModel extends ChangeNotifier {
  final PertumbuhanService _service = PertumbuhanService();

  List<Anak> _daftarAnak = [];
  List<Pertumbuhan> _dataPertumbuhan = [];
  Anak? _selectedAnak;
  String _selectedGrafik = 'Semua';
  bool _isLoading = false;
  String deskripsiGrafik = '';
  bool isLoadingDeskripsi = false;

  List<Anak> get daftarAnak => _daftarAnak;
  List<Pertumbuhan> get dataPertumbuhan => _dataPertumbuhan;
  Anak? get selectedAnak => _selectedAnak;
  String get selectedGrafik => _selectedGrafik;
  bool get isLoading => _isLoading;

  void setSelectedAnak(Anak anak) async {
    _selectedAnak = anak;
    deskripsiGrafik = '';
    _dataPertumbuhan = [];
    notifyListeners();

    await _loadPertumbuhanData(anak.id);

    // Setelah data pertumbuhan update, generate deskripsi
    await generateDeskripsiAI();
  }

  void setSelectedGrafik(String jenis) async {
    _selectedGrafik = jenis;
    deskripsiGrafik = '';
    notifyListeners();

    // Regenerate deskripsi saat grafik berubah
    await generateDeskripsiAI();
  }

  Future<void> init(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _daftarAnak = await _service.getAnakList(userId);
      if (_daftarAnak.isNotEmpty) {
        _selectedAnak = _daftarAnak[0];
        await _loadPertumbuhanData(_selectedAnak!.id);
        await generateDeskripsiAI();
      } else {
        await generateDeskripsiAI();
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
      _dataPertumbuhan = [];
    }
    notifyListeners();
  }

  Future<void> generateDeskripsiAI() async {
    if (dataPertumbuhan.isEmpty || selectedGrafik.isEmpty) {
      deskripsiGrafik = '';
      notifyListeners();
      return;
    }

    final latestData = dataPertumbuhan.last;
    final status = latestData.statusGizi;
    if (status == null) {
      deskripsiGrafik = '';
      notifyListeners();
      return;
    }

    // Hilangkan pengecekan ini supaya deskripsi bisa diperbarui saat pindah anak/grafik
    // if (deskripsiGrafik.isNotEmpty) return;

    try {
      isLoadingDeskripsi = true;
      notifyListeners();

      final chatbotService = ChatBotService();
      final response = await chatbotService.getGrafikDeskripsi(
        jenisGrafik: selectedGrafik,
        statusBBU: status.statusBBU,
        zscoreBBU: status.zscoreBBU.toStringAsFixed(2),
        statusTBU: status.statusTBU,
        zscoreTBU: status.zscoreTBU.toStringAsFixed(2),
        statusBBTB: status.statusBBTB,
        zscoreBBTB: status.zscoreBBTB.toStringAsFixed(2),
      );

      deskripsiGrafik = response.trim();
    } catch (e) {
      deskripsiGrafik = 'Deskripsi gagal dimuat. $e';
    } finally {
      isLoadingDeskripsi = false;
      notifyListeners();
    }
  }
}
