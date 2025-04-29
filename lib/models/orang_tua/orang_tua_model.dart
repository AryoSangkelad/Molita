class OrangTua {
  final String idOrangTua;
  final String? idAdmin;
  final String? idPosyandu;
  final String? username;
  final String? email;
  final String namaIbu;
  final String namaAyah;
  final String nikIbu;
  final String nikAyah;
  final String alamat;
  final String noTelepon;
  final String statusAktivasi;

  OrangTua({
    required this.idOrangTua,
    this.idAdmin,
    this.idPosyandu,
    this.username,
    this.email,
    required this.namaIbu,
    required this.namaAyah,
    required this.nikIbu,
    required this.nikAyah,
    required this.alamat,
    required this.noTelepon,
    required this.statusAktivasi,
  });

  factory OrangTua.fromJson(Map<String, dynamic> json) {
    return OrangTua(
      idOrangTua: json['id_orang_tua'],
      idAdmin: json['id_admin'],
      idPosyandu: json['id_posyandu'],
      username: json['username'],
      email: json['email'],
      namaIbu: json['nama_ibu'],
      namaAyah: json['nama_ayah'],
      nikIbu: json['nik_ibu'],
      nikAyah: json['nik_ayah'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      statusAktivasi: json['status_aktivasi'],
    );
  }
}
