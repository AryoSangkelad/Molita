import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/services/AuthService.dart';
import 'package:molita_flutter/models/common/register_model.dart';

class RegisterViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _loading = false;

  bool get isPasswordHidden => _isPasswordHidden;
  bool get isConfirmPasswordHidden => _isConfirmPasswordHidden;
  bool get loading => _loading;

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    notifyListeners();
  }

  Future<String?> register() async {
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return 'Semua field harus diisi';
    }

    if (password != confirmPassword) {
      return 'Password dan konfirmasi password tidak sama';
    }

    _loading = true;
    notifyListeners();

    try {
      final registerData = RegisterModel(
        email: email,
        username: username,
        password: password,
      );

      final message = await _authService.register(registerData);

      _loading = false;
      notifyListeners();
      return message;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return e.toString();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
