import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/common/register_model.dart';

class AuthService {
  Future<Map<String, dynamic>> login(
    String emailOrUsername,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.baseUrlApi}/login'),
        body: {'email_or_username': emailOrUsername, 'password': password},
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          body['role'] != null &&
          body['data'] != null) {
        return {
          'success': true,
          'role': body['role'],
          'message': body['message'],
          'data': body['data'], // penting: untuk disimpan ke SharedPreferences
        };
      } else {
        return {'success': false, 'message': body['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi.'};
    }
  }

  Future<String> register(RegisterModel data) async {
    print("AMAN0");
    final response = await http.post(
      Uri.parse('${AppConstant.baseUrlApi}/register-orang-tua'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data.toJson()),
    );

    print("AMAN0");
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("AMANA");
      return result['message'];
    } else {
      print("AMANA3");
      return result['message'] ?? 'Terjadi kesalahan saat mendaftar';
    }
  }
}
