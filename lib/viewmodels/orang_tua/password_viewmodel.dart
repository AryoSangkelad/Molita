import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/passwordService.dart';

class PasswordViewModel extends ChangeNotifier {
  final PasswordService _passwordService = PasswordService();

  bool isLoading = false;
  String? message;

  Future<bool> gantiPassword({
    required String email,
    required String passwordLama,
    required String passwordBaru,
    required String confirmPassword,
  }) async {
    isLoading = true;
    message = null;
    notifyListeners();

    try {
      final result = await _passwordService.gantiPassword(
        email: email,
        passwordLama: passwordLama,
        passwordBaru: passwordBaru,
        confirmPassword: confirmPassword,
      );
      message = result.message;
      return true;
    } catch (e) {
      message = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
