import 'dart:convert';

import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:http/http.dart' as http;

class AnakService {
  Future<List<Anak>> getAllByOrangTua(String userId) async {
    final response = await http.get(
      Uri.parse('${AppConstant.baseUrlApi}/anak/orang-tua/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Anak.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data anak');
    }
  }

  Future<Anak> getById(String anakId) async {
    final response = await http.get(
      Uri.parse('${AppConstant.baseUrlApi}/anak/$anakId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Anak.fromJson(data);
    } else {
      throw Exception('Gagal memuat data detail anak');
    }
  }
}
