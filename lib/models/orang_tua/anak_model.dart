class Anak {
  final String id;
  final String nama;
  final DateTime tanggalLahir;
  final String alamat;
  final String jenisKelamin;
  final String? idOrangTua;
  final int? idDesa;

  Anak({
    required this.id,
    required this.nama,
    required this.tanggalLahir,
    required this.alamat,
    required this.jenisKelamin,
    this.idOrangTua,
    this.idDesa,
  });

  factory Anak.fromJson(Map<String, dynamic> json) {
    return Anak(
      id: json['id_anak'],
      nama: json['nama_anak'],
      tanggalLahir: DateTime.parse(json['tanggal_lahir']),
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
      idOrangTua: json['id_orang_tua'],
      idDesa:
          json['id_desa'] != null
              ? int.tryParse(json['id_desa'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_anak': id,
      'nama_anak': nama,
      'tanggal_lahir': tanggalLahir.toIso8601String(),
      'alamat': alamat,
      'jenis_kelamin': jenisKelamin,
      'id_orang_tua': idOrangTua,
      'id_desa': idDesa,
    };
  }
}

class AnakS {
  final String id;
  final String nama;
  final DateTime tanggalLahir;

  AnakS({required this.id, required this.nama, required this.tanggalLahir});
}
