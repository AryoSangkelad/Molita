
// Pertumbuhan Model
class Pertumbuhan {
  final String id;
  final String idAnak;
  final DateTime tanggalPencatatan;
  final double beratBadan;
  final double tinggiBadan;
  final double lingkarKepala;

  Pertumbuhan({
    required this.id,
    required this.idAnak,
    required this.tanggalPencatatan,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarKepala,
  });

  factory Pertumbuhan.fromJson(Map<String, dynamic> json) {
    return Pertumbuhan(
      id: json['id_pertumbuhan'],
      idAnak: json['id_anak'],
      tanggalPencatatan: DateTime.parse(json['tanggal_pencatatan']),
      beratBadan: double.tryParse(json['berat_badan'].toString()) ?? 0.0,
      tinggiBadan: double.tryParse(json['tinggi_badan'].toString()) ?? 0.0,
      lingkarKepala: double.tryParse(json['lingkar_kepala'].toString()) ?? 0.0,
    );
  }
}