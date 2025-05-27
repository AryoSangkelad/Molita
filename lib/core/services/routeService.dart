import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:molita_flutter/models/orang_tua/route_model.dart';

class RouteService {
  static const _baseUrl =
      'https://api.openrouteservice.org/v2/directions/driving-car';
  static const _apiKey =
      '5b3ce3597851110001cf6248035e96f86d734633a32bff97184bc10a';

  Future<RouteModel> fetchRoute(LatLng start, LatLng end) async {
    final url = Uri.parse('$_baseUrl?api_key=$_apiKey');

    final body = jsonEncode({
      'coordinates': [
        [start.longitude, start.latitude],
        [end.longitude, end.latitude],
      ],
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("SNKSN ${data}");
      return RouteModel.fromJson(data);
    } else {
      throw Exception('Gagal mengambil rute: ${response.body}');
    }
  }
}
