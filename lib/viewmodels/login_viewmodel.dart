import 'package:flutter/material.dart';
import 'package:molita_flutter/models/login_model.dart';


class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? loginMessage;

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      loginMessage = "Email dan password wajib diisi!";
    } else {
      // Simulasi login sukses
      UserModel user = UserModel(email: email, password: password);
      loginMessage = "Login berhasil untuk ${user.email}";
    }

    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
