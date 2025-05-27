class KategoriPengaduan {
  final int id;
  final String nama;

  KategoriPengaduan({required this.id, required this.nama});

  factory KategoriPengaduan.fromJson(Map<String, dynamic> json) {
    return KategoriPengaduan(id: json['id'], nama: json['nama']);
  }
}
