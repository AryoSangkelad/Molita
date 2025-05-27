import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/password_update_response.dart';
import 'dart:convert';

class PasswordViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? message;

  Future<bool> gantiPassword({
    required String email,
    required String passwordLama,
    required String passwordBaru,
    required String confirmPassword,
  }) async {
    isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('${AppConstant.baseUrlApi}/orang-tua/ganti-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password_lama': passwordLama,
        'password_baru': passwordBaru,
        'password_baru_confirmation': confirmPassword,
      }),
    );

    isLoading = false;

    if (response.statusCode == 200) {
      message = PasswordUpdateResponse.fromJson(json.decode(response.body)).message;
      notifyListeners();
      return true;
    } else {
      message = json.decode(response.body)['message'];
      notifyListeners();
      return false;
    }
  }
}
