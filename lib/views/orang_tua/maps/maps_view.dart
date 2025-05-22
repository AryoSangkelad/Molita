import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:molita_flutter/viewmodels/orang_tua/maps_viewmodel.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final MapController _mapController = MapController();
  List<LatLng> routePoints = [];
  bool _routeFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<MapsViewModel>(context);
    if (_shouldFetchRoute(viewModel)) {
      fetchRoute();
    }
  }

  bool _shouldFetchRoute(MapsViewModel viewModel) {
    return !_routeFetched &&
        viewModel.orangTua != null &&
        viewModel.jenisPosyandu != null &&
        viewModel.orangTua!.latitude != null &&
        viewModel.orangTua!.longitude != null &&
        viewModel.jenisPosyandu!.latitude != null &&
        viewModel.jenisPosyandu!.longitude != null;
  }

  Future<void> fetchRoute() async {
    final viewModel = Provider.of<MapsViewModel>(context, listen: false);
    try {
      final coords = await _getRouteCoordinates(viewModel);
      if (coords.isEmpty) return;

      setState(() {
        routePoints = coords;
        _routeFetched = true;
      });
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  Future<List<LatLng>> _getRouteCoordinates(MapsViewModel viewModel) async {
    final startPoint = _parsePosition(viewModel.orangTua!);
    final endPoint = _parsePosition(viewModel.jenisPosyandu!);

    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${startPoint.longitude},${startPoint.latitude};'
        '${endPoint.longitude},${endPoint.latitude}?geometries=geojson';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final routes = data['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) return [];

    final coords = routes[0]['geometry']['coordinates'] as List<dynamic>?;
    return coords?.map<LatLng>((p) => LatLng(p[1], p[0])).toList() ?? [];
  }

  LatLng _parsePosition(dynamic model) {
    return LatLng(
      _parseCoordinate(model.latitude),
      _parseCoordinate(model.longitude),
    );
  }

  double _parseCoordinate(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapsViewModel>(context);

    if (viewModel.orangTua == null || viewModel.jenisPosyandu == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final startPoint = _parsePosition(viewModel.orangTua!);
    final endPoint = _parsePosition(viewModel.jenisPosyandu!);

    return Scaffold(
      appBar: AppBar(title: const Text("Rute ke Posyandu")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(center: startPoint, zoom: 13),
        children: [
          _buildTileLayer(),
          _buildMarkers(startPoint, endPoint),
          _buildRouteLayer(),
        ],
      ),
    );
  }

  TileLayer _buildTileLayer() {
    return TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
    );
  }

  MarkerLayer _buildMarkers(LatLng start, LatLng end) {
    return MarkerLayer(
      markers: [
        _buildIconMarker(start, Icons.person_pin_circle, Colors.blue),
        _buildIconMarker(end, Icons.local_hospital, Colors.green),
      ],
    );
  }

  Marker _buildIconMarker(LatLng point, IconData icon, Color color) {
    return Marker(point: point, child: Icon(icon, color: color, size: 40));
  }

  Widget _buildRouteLayer() {
    if (routePoints.isEmpty) return const SizedBox.shrink();

    return PolylineLayer(
      polylines: [
        Polyline(points: routePoints, strokeWidth: 4.0, color: Colors.green),
      ],
    );
  }
}
