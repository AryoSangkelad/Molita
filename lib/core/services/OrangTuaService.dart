import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/models/orang_tua/otp_response.dart';

class OrangTuaService {
  Future<OrangTua?> fetchOrangTua(String idOrangTua) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstant.baseUrlApi}/orang-tua/$idOrangTua'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          return OrangTua.fromJson(jsonData['data']);
        }
      }
      return null;
    } catch (e) {
      print("Fetch error: $e");
      return null;
    }
  }

  Future<OrangTua> updateProfile(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstant.baseUrlApi}/orang-tua/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return OrangTua.fromJson(responseData['data']);
      } else {
        throw Exception('Gagal memperbarui profil: ${response.statusCode}');
      }
    } catch (e) {
      print("Error update profile: $e");
      throw Exception('Gagal memperbarui profil');
    }
  }

  Future<String> uploadPhoto(String id, String imagePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstant.baseUrlApi}/orang-tua/$id/upload-foto'),
      );

      request.files.add(await http.MultipartFile.fromPath('foto', imagePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']['img'];
      } else {
        throw Exception('Gagal mengunggah foto: ${response.statusCode}');
      }
    } catch (e) {
      print("Error upload foto: $e");
      throw Exception('Gagal mengunggah foto');
    }
  }

  Future<OtpResponse> sendOtp(String username, String email) async {
    final response = await http.post(
      Uri.parse('${AppConstant.baseUrlApi}/orang-tua/forgot-password'),
      body: {'username': username, 'email': email},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return OtpResponse.fromJson(data);
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> verifyOtp(String username, String kodeOtp) async {
    final response = await http.post(
      Uri.parse('${AppConstant.baseUrlApi}/orang-tua/verify-otp'),
      body: {'username': username, 'kode_otp': kodeOtp},
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  Future<void> resetPassword(String username, String newPassword) async {
    final response = await http.post(
      Uri.parse('${AppConstant.baseUrlApi}/orang-tua/reset-password'),
      body: {'username': username, 'password_baru': newPassword},
    );

    if (response.statusCode != 200) {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
