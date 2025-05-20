class OrangTua {
  final String? idOrangTua;
  final String? idAdmin;
  final String? idJenisPosyandu;
  final String? username;
  final String? email;
  final String? namaIbu;
  final String? namaAyah;
  final String? nikIbu;
  final String? nikAyah;
  final String? alamat;
  final String? noTelepon;
  final String? statusAktivasi;
  final String? tokenOrangTua;
  final String? img;
  final int? idDesa;
  final double? latitude;
  final double? longitude;

  OrangTua({
    this.idOrangTua,
    this.idAdmin,
    this.idJenisPosyandu,
    this.username,
    this.email,
    this.namaIbu,
    this.namaAyah,
    this.nikIbu,
    this.nikAyah,
    this.alamat,
    this.noTelepon,
    this.statusAktivasi,
    this.tokenOrangTua,
    this.img,
    this.idDesa,
    this.latitude,
    this.longitude,
  });

  factory OrangTua.fromJson(Map<String, dynamic> json) {
    return OrangTua(
      idOrangTua: json['id_orang_tua'],
      idAdmin: json['id_admin'],
      idJenisPosyandu: json['id_jenis_posyandu'],
      username: json['username'],
      email: json['email'],
      namaIbu: json['nama_ibu'],
      namaAyah: json['nama_ayah'],
      nikIbu: json['nik_ibu'],
      nikAyah: json['nik_ayah'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      statusAktivasi: json['status_aktivasi'],
      tokenOrangTua: json['token_orang_tua'],
      img: json['img'],
      idDesa: json['id_desa'],
      latitude:
          json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (idOrangTua != null) data['id_orang_tua'] = idOrangTua;
    if (idAdmin != null) data['id_admin'] = idAdmin;
    if (idJenisPosyandu != null) data['id_jenis_posyandu'] = idJenisPosyandu;
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (namaIbu != null) data['nama_ibu'] = namaIbu;
    if (namaAyah != null) data['nama_ayah'] = namaAyah;
    if (nikIbu != null) data['nik_ibu'] = nikIbu;
    if (nikAyah != null) data['nik_ayah'] = nikAyah;
    if (alamat != null) data['alamat'] = alamat;
    if (noTelepon != null) data['no_telepon'] = noTelepon;
    if (statusAktivasi != null) data['status_aktivasi'] = statusAktivasi;
    if (tokenOrangTua != null) data['token_orang_tua'] = tokenOrangTua;
    if (img != null) data['img'] = img;
    if (idDesa != null) data['id_desa'] = idDesa;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;

    return data;
  }
}
