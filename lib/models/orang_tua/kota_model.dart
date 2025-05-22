import 'provinsi_model.dart';

class Kota {
  final int id;
  final String nama;
  final Provinsi provinsi;

  Kota({required this.id, required this.nama, required this.provinsi});

  factory Kota.fromJson(Map<String, dynamic> json) {
    return Kota(
      id: json['id_kota'],
      nama: json['nama_kota'],
      provinsi: Provinsi.fromJson(json['provinsi']),
    );
  }
}
