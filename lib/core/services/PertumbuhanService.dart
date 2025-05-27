import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/pertumbuhan_model.dart';

class PertumbuhanService {
  Future<List<Anak>> getAnakList(String userId) async {
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

  Future<List<Pertumbuhan>> getPertumbuhanData(String idAnak) async {
    final response = await http.get(
      Uri.parse('${AppConstant.baseUrlApi}/pertumbuhan/anak/$idAnak'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pertumbuhan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data pertumbuhan');
    }
  }
}
