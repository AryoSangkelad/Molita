// lib/services/edukasi_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/artikel_edukasi_model.dart';
import 'package:molita_flutter/models/orang_tua/jenis_edukasi.dart';
import 'package:molita_flutter/models/orang_tua/video_edukasi_model.dart';

class EdukasiService {
  Future<List<JenisEdukasi>> getJenisEdukasi() async {
    final response = await http.get(
      Uri.parse('${AppConstant.baseUrlApi}/edukasi/jenis'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => JenisEdukasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load jenis edukasi');
    }
  }

  Future<List<ArtikelEdukasi>> getArtikel() async {
    final response = await http.get(
      Uri.parse('${AppConstant.baseUrlApi}/edukasi/artikel'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ArtikelEdukasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load artikel');
    }
  }

  Future<List<VideoEdukasi>> getVideo() async {
    final response = await http.get(
      Uri.parse('${AppConstant.baseUrlApi}/edukasi/video'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => VideoEdukasi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load video');
    }
  }
}
