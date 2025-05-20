import 'package:flutter/material.dart';

class JadwalPosyandu {
  final String id;
  final String kegiatan;
  final DateTime tanggal;
  final TimeOfDay jamMulai;
  final TimeOfDay jamSelesai;
  final String catatan;
  final String lokasi;

  JadwalPosyandu({
    required this.id,
    required this.kegiatan,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.catatan,
    required this.lokasi,
  });
}
