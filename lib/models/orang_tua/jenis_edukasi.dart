class JenisEdukasi {
  final String idJenisEdukasi;
  final String idSuperAdmin;
  final String judul;
  final String slug;

  JenisEdukasi({
    required this.idJenisEdukasi,
    required this.idSuperAdmin,
    required this.judul,
    required this.slug,
  });

  factory JenisEdukasi.fromJson(Map<String, dynamic> json) {
    return JenisEdukasi(
      idJenisEdukasi: json['id_jenis_edukasi'],
      idSuperAdmin: json['id_super_admin'],
      judul: json['judul'],
      slug: json['slug'],
    );
  }
}
