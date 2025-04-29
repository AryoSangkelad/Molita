import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';

class AuthService {
  Future<OrangTua?> login(String emailOrUsername, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrl}/orang-tua/login'),
      body: {'email_or_username': emailOrUsername, 'password': password},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final orangTua = OrangTua.fromJson(body['data']);
      print("AMANANNANANA");
      return orangTua;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
