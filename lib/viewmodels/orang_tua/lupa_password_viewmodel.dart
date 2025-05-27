// viewmodels/lupa_password_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/OrangTuaService.dart';

class LupaPasswordViewModel extends ChangeNotifier {
  final _service = OrangTuaService();

  bool isLoading = false;
  String message = '';

  Future<void> kirimOtp(String username, String email) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _service.sendOtp(username, email);
      message = result.message;
    } catch (e) {
      message = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> verifikasiOtp(String username, String otp) async {
    try {
      await _service.verifyOtp(username, otp);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> gantiPassword(String username, String passwordBaru) async {
    try {
      await _service.resetPassword(username, passwordBaru);
      return true;
    } catch (_) {
      return false;
    }
  }
}
