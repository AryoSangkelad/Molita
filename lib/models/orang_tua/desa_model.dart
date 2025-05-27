import 'kecamatan_model.dart';

class Desa {
  final int id;
  final String nama;

  Desa({required this.id, required this.nama});

  factory Desa.fromJson(Map<String, dynamic> json) {
    return Desa(id: json['id_desa'] ?? 0, nama: json['nama_desa'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id_desa': id, 'nama_desa': nama};
  }
}

class DesaDua {
  final int id;
  final String nama;
  final Kecamatan kecamatan;

  DesaDua({required this.id, required this.nama, required this.kecamatan});

  factory DesaDua.fromJson(Map<String, dynamic> json) {
    return DesaDua(
      id: json['id_desa'],
      nama: json['nama_desa'],
      kecamatan: Kecamatan.fromJson(json['kecamatan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_desa': id, 'nama': nama};
  }
}
