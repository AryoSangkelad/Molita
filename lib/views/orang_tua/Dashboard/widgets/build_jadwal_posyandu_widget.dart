import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';
import 'package:molita_flutter/models/orang_tua/jenis_posyandu_model.dart';

Widget buildJadwalPosyandu(
  BuildContext context,
  JenisPosyandu jenisPosyandu,
  JadwalPosyandu jadwalPosyandu,
) {
  final primaryColor = Theme.of(context).colorScheme.primary;
  final textTheme = Theme.of(context).textTheme;

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
                    '${jenisPosyandu.pos}',
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
                          '${jenisPosyandu.alamat}',
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
  JadwalPosyandu jadwalPosyandu,
) async {
  final primaryColor = Theme.of(context).colorScheme.primary;
  final textTheme = Theme.of(context).textTheme;
  final screenHeight = MediaQuery.of(context).size.height;
  LatLng? userLocation;
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layanan lokasi tidak aktif')),
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak')));
    } else {
      Position position = await Geolocator.getCurrentPosition();
      userLocation = LatLng(position.latitude, position.longitude);
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Gagal mendapatkan lokasi: $e')));
  }

  LatLng _parsePosition(dynamic model) {
    return LatLng(
      _parseCoordinate(model.latitude),
      _parseCoordinate(model.longitude),
    );
  }

  final distance =
      userLocation != null
          ? Distance().as(
            LengthUnit.Kilometer,
            userLocation,
            _parsePosition(jenisPosyandu),
          )
          : null;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.85,
            minHeight: screenHeight * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Detail Posyandu',
                          style: textTheme.headlineSmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: FlutterMap(
                            options: MapOptions(
                              center: _parsePosition(jenisPosyandu),
                              zoom: 15.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                                subdomains: ['a', 'b', 'c'],
                              ),
                              MarkerLayer(
                                markers: [
                                  if (userLocation != null)
                                    Marker(
                                      point: userLocation,
                                      width: 40,
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person_pin_circle,
                                          color: Colors.blue,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  Marker(
                                    point: _parsePosition(jenisPosyandu),
                                    width: 48,
                                    height: 48,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.local_hospital_rounded,
                                        color: primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              PolylineLayer(
                                polylines: [
                                  if (userLocation != null)
                                    Polyline(
                                      points: [
                                        userLocation,
                                        _parsePosition(jenisPosyandu),
                                      ],
                                      strokeWidth: 3.0,
                                      color: primaryColor.withOpacity(0.7),
                                      borderStrokeWidth: 1,
                                      borderColor: Colors.white,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildModernDetailRow(
                        context,
                        icon: Icons.location_on,
                        title: 'Lokasi',
                        value: '${jenisPosyandu.alamat}',
                      ),
                      _buildModernDetailRow(
                        context,
                        icon: Icons.event,
                        title: 'Tanggal',
                        value:
                            '${jadwalPosyandu.tanggal.toLocal()}'.split(
                              ' ',
                            )[0], // formatting tanggal
                      ),
                      _buildModernDetailRow(
                        context,
                        icon: Icons.schedule,
                        title: 'Waktu',
                        value:
                            '${jadwalPosyandu.jamMulai.format(context)} - ${jadwalPosyandu.jamSelesai.format(context)}',
                      ),
                      _buildModernDetailRow(
                        context,
                        icon: Icons.assignment,
                        title: 'Kegiatan',
                        value: '${jadwalPosyandu.kegiatan}',
                      ),
                      _buildModernDetailRow(
                        context,
                        icon: Icons.note,
                        title: 'Catatan',
                        value: jadwalPosyandu.catatan ?? '-',
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
  );
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
              Text(
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

double _parseCoordinate(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
