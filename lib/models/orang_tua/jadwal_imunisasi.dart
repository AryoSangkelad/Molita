class JadwalImunisasi {
  final String id;
  final String vaksin;
  final int usiaPemberian; // dalam bulan
  final DateTime tanggal;
  final String statusImunisasi;
  final String namaBidan;
  final String alamat;

  JadwalImunisasi({
    required this.id,
    required this.vaksin,
    required this.usiaPemberian,
    required this.tanggal,
    required this.statusImunisasi,
    required this.namaBidan,
    required this.alamat,
  });
}
