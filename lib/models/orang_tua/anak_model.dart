// anak_model.dart
import 'desa_model.dart';

class Anak {
  final String id;
  final String nama;
  final DateTime? tanggalLahir;
  final String alamat;
  final String jenisKelamin;
  final String? idOrangTua;
  final int? idDesa;
  final DesaDua? desa;

  Anak({
    required this.id,
    required this.nama,
    required this.tanggalLahir,
    required this.alamat,
    required this.jenisKelamin,
    this.idOrangTua,
    this.idDesa,
    this.desa,
  });

  factory Anak.fromJson(Map<String, dynamic> json) {
    return Anak(
      id: json['id_anak'],
      nama: json['nama_anak'],
      tanggalLahir:
          json['tanggal_lahir'] != null
              ? DateTime.tryParse(json['tanggal_lahir'])
              : null,
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
      idOrangTua: json['id_orang_tua'],
      idDesa:
          json['id_desa'] != null
              ? int.tryParse(json['id_desa'].toString())
              : null,
      desa: json['desa'] != null ? DesaDua.fromJson(json['desa']) : null,
    );
  }
}
