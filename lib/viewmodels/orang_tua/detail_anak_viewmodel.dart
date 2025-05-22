import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/AnakService.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';

class DetailAnakViewModel extends ChangeNotifier {
  final AnakService _anakService = AnakService();

  Anak? anak;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchDetailAnak(String anakId) async {
    isLoading = true;
    notifyListeners();

    try {
      anak = await _anakService.getById(anakId);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      anak = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
