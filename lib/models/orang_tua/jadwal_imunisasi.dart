class JadwalImunisasi {
  final String id;
  final String namaImunisasi;
  final int usiaPemberian; 
  final DateTime tanggal;
  final String statusImunisasi;
  final String namaBidan;
  final String alamat;

  JadwalImunisasi({
    required this.id,
    required this.namaImunisasi,
    required this.usiaPemberian,
    required this.tanggal,
    required this.statusImunisasi,
    required this.namaBidan,
    required this.alamat,
  });
}
