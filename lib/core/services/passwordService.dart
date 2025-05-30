import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/password_update_response.dart';

class PasswordService {
  Future<PasswordUpdateResponse> gantiPassword({
    required String email,
    required String passwordLama,
    required String passwordBaru,
    required String confirmPassword,
  }) async {
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

    final jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return PasswordUpdateResponse.fromJson(jsonData);
    } else {
      throw Exception(jsonData['message']);
    }
  }
}
