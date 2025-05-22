// desa_model.dart
import 'kecamatan_model.dart';

class Desa {
  final int id;
  final String nama;
  final Kecamatan kecamatan;

  Desa({required this.id, required this.nama, required this.kecamatan});

  factory Desa.fromJson(Map<String, dynamic> json) {
    return Desa(
      id: json['id_desa'],
      nama: json['nama_desa'],
      kecamatan: Kecamatan.fromJson(json['kecamatan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_desa': id, 'nama': nama};
  }
}
