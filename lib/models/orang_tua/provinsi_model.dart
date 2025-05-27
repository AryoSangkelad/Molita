// provinsi_model.dart
class Provinsi {
  final int id;
  final String nama;

  Provinsi({required this.id, required this.nama});

  factory Provinsi.fromJson(Map<String, dynamic> json) {
    return Provinsi(id: json['id_provinsi'], nama: json['nama_provinsi']);
  }
}
 