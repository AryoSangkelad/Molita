import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:molita_flutter/core/services/routeService.dart';
import 'package:molita_flutter/models/orang_tua/route_model.dart';

class RouteViewModel extends ChangeNotifier {
  final RouteService _service = RouteService();
  RouteModel? _route;
  bool _isLoading = false;
  String? _error;

  RouteModel? get route => _route;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getRoute(LatLng start, LatLng end) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _route = await _service.fetchRoute(start, end);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
