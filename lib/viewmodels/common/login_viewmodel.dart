import 'package:flutter/material.dart';
import 'package:molita_flutter/core/services/AuthService.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailorUsernameController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  OrangTua? orangTua;
  bool isLoading = false;
  String? errorMessage;

  Future<void> login(String emailOrUsername, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      orangTua = await _authService.login(emailOrUsername, password);
      errorMessage = null;
    } catch (e) {
      orangTua = null;
      errorMessage = e.toString();
      print(errorMessage);
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailorUsernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
