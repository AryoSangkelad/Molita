import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as Htmls;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';
import 'package:molita_flutter/models/orang_tua/jenis_posyandu_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/route_viewmodel.dart';
import 'package:provider/provider.dart';

Widget buildJadwalPosyandu(
  BuildContext context,
  JenisPosyandu? jenisPosyandu,
  JadwalPosyandu? jadwalPosyandu,
) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  final textTheme = Theme.of(context).textTheme;

  if (jenisPosyandu == null) return const SizedBox.shrink();

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showPosyanduDetails(context, jenisPosyandu, jadwalPosyandu),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jenisPosyandu.pos,
                    style: textTheme.titleMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          jenisPosyandu.alamat,
                          style: textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    ),
  );
}

void _showPosyanduDetails(
  BuildContext context,
  JenisPosyandu jenisPosyandu,
  JadwalPosyandu? jadwalPosyandu,
) {
  final posyanduLocation = _parseLatLng(jenisPosyandu);

  final routeViewModel = RouteViewModel();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => ChangeNotifierProvider.value(
          value: routeViewModel,
          child: _PosyanduDetailContent(
            posyanduLocation: posyanduLocation,
            jenisPosyandu: jenisPosyandu,
            jadwalPosyandu: jadwalPosyandu,
          ),
        ),
  );
}

LatLng _parseLatLng(JenisPosyandu posyandu) {
  return LatLng(
    _parseCoordinate(posyandu.latitude),
    _parseCoordinate(posyandu.longitude),
  );
}

double _parseCoordinate(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class _PosyanduDetailContent extends StatefulWidget {
  final LatLng posyanduLocation;
  final JenisPosyandu jenisPosyandu;
  final JadwalPosyandu? jadwalPosyandu;

  const _PosyanduDetailContent({
    required this.posyanduLocation,
    required this.jenisPosyandu,
    required this.jadwalPosyandu,
  });

  @override
  State<_PosyanduDetailContent> createState() => _PosyanduDetailContentState();
}

class _PosyanduDetailContentState extends State<_PosyanduDetailContent> {
  LatLng? _userLocation;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  void _initLocationTracking() async {
    final viewModel = Provider.of<RouteViewModel>(context, listen: false);

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      if (await Geolocator.isLocationServiceEnabled()) {
        final position = await Geolocator.getCurrentPosition();
        _userLocation = LatLng(position.latitude, position.longitude);

        await viewModel.getRoute(_userLocation!, widget.posyanduLocation);

        _positionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(distanceFilter: 10),
        ).listen((Position pos) async {
          final newLocation = LatLng(pos.latitude, pos.longitude);
          if (_userLocation != newLocation) {
            setState(() => _userLocation = newLocation);
            await viewModel.getRoute(_userLocation!, widget.posyanduLocation);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mendapatkan lokasi: $e")));
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Detail Posyandu',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Consumer<RouteViewModel>(
                        builder: (context, viewModel, _) {
                          return FlutterMap(
                            options: MapOptions(
                              center: _userLocation ?? widget.posyanduLocation,
                              zoom: 15,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              if (!viewModel.isLoading &&
                                  viewModel.route?.routePoints.isNotEmpty ==
                                      true)
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: viewModel.route!.routePoints,
                                      strokeWidth: 4.5,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              MarkerLayer(
                                markers: [
                                  if (_userLocation != null)
                                    Marker(
                                      width: 40,
                                      height: 40,
                                      point: _userLocation!,
                                      child: const Icon(
                                        Icons.person_pin_circle,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  Marker(
                                    width: 40,
                                    height: 40,
                                    point: widget.posyanduLocation,
                                    child: Icon(
                                      Icons.local_hospital_rounded,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildModernDetailRow(
                    context,
                    icon: Icons.location_on,
                    title: 'Alamat',
                    value: widget.jenisPosyandu.alamat,
                  ),
                  _buildModernDetailRow(
                    context,
                    icon: Icons.event,
                    title: 'Tanggal',
                    value:
                        widget.jadwalPosyandu != null
                            ? '${widget.jadwalPosyandu?.tanggal.toLocal()}'
                                .split(' ')[0]
                            : '-',
                  ),
                  _buildModernDetailRow(
                    context,
                    icon: Icons.schedule,
                    title: 'Waktu',
                    value:
                        widget.jadwalPosyandu != null
                            ? '${widget.jadwalPosyandu?.jamMulai.format(context)} - ${widget.jadwalPosyandu?.jamSelesai.format(context)}'
                            : '-',
                  ),
                  _buildModernDetailRow(
                    context,
                    icon: Icons.assignment,
                    title: 'Kegiatan',
                    value: widget.jadwalPosyandu?.kegiatan ?? '-',
                  ),
                  _buildModernDetailRow(
                    context,
                    icon: Icons.note,
                    title: 'Catatan',
                    value: widget.jadwalPosyandu?.catatan ?? '-',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildModernDetailRow(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
}) {
  final colors = Theme.of(context).colorScheme;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: colors.surfaceVariant.withOpacity(0.4),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: colors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              // Misalnya: gunakan boolean isHtml untuk menentukan apakah value adalah HTML
              (icon == Icons.note)
                  ? Htmls.Html(
                    data: "value",
                    style: {
                      "body": Htmls.Style(
                        fontSize: Htmls.FontSize(16),
                        color: Colors.grey[800],
                        margin: Htmls.Margins.all(0),
                        padding: Htmls.HtmlPaddings.all(0),
                      ),
                    },
                  )
                  : Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ],
          ),
        ),
      ],
    ),
  );
}
