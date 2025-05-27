class Pengaduan {
  final String idOrangTua;
  final String judul;
  final String deskripsi;
  final int kategoriId;
  final String? status;
  final String? lampiran;
  final String? tanggapan;
  final String? namaKategori;
  final String? lampiranUrl;
  final String? createdAt; // Tambahan: timestamp lengkap
  final String? createdDate; // Tambahan: tanggal saja

  Pengaduan({
    required this.idOrangTua,
    required this.judul,
    required this.deskripsi,
    required this.kategoriId,
    this.namaKategori,
    this.status,
    this.lampiran,
    this.tanggapan,
    this.lampiranUrl,
    this.createdAt,
    this.createdDate,
  });

  factory Pengaduan.fromJson(Map<String, dynamic> json) {
    return Pengaduan(
      idOrangTua: json['id_orang_tua'] ?? '',
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kategoriId:
          json['kategori_id'] is int
              ? json['kategori_id']
              : int.tryParse(json['kategori_id'].toString()) ?? 0,
      status: json['status'],
      namaKategori: json['kategori_nama'],
      lampiran: json['lampiran'],
      tanggapan: json['tanggapan'],
      lampiranUrl: json['lampiran_url'],
      createdAt: json['created_at'],
      createdDate: json['created_date'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'id_orang_tua': idOrangTua,
      'judul': judul,
      'deskripsi': deskripsi,
      'kategori_id': kategoriId,
    };
    if (lampiran != null) {
      map['lampiran'] = lampiran!;
    }
    return map;
  }
}
