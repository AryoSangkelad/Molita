import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart'; // kalau pakai latlong

class RouteModel {
  final List<LatLng> routePoints;

  RouteModel({required this.routePoints});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final encodedPolyline = json['routes'][0]['geometry'] as String;

    List<PointLatLng> decodedPoints = PolylinePoints().decodePolyline(
      encodedPolyline,
    );

    // konversi ke LatLng
    List<LatLng> routePoints =
        decodedPoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

    return RouteModel(routePoints: routePoints);
  }
}
