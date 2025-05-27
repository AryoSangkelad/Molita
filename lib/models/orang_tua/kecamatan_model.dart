// kecamatan_model.dart
import 'kota_model.dart';

class Kecamatan {
  final int id;
  final String nama;
  final Kota kota;

  Kecamatan({required this.id, required this.nama, required this.kota});

  factory Kecamatan.fromJson(Map<String, dynamic> json) {
    return Kecamatan(
      id: json['id_kecamatan'],
      nama: json['nama_kecamatan'],
      kota: Kota.fromJson(json['kota']),
    );
  }
}
