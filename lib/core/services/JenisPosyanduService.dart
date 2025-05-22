import 'dart:convert';

import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:http/http.dart' as http;

class JenisPosyanduService {
  /// Get all Jenis Posyandu
  Future<List<dynamic>> getAll() async {
    final response = await http.get(
      Uri.parse('${ApiConstant.baseUrlApi}/jenis-posyandu'),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Failed to load jenis posyandu');
    }
  }

  /// Get Jenis Posyandu by ID
  Future<Map<String, dynamic>> getById(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConstant.baseUrlApi}/jenis-posyandu/$id'),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Jenis Posyandu with ID $id not found');
    }
  }
}
