// services/schedule_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_imunisasi.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';
import 'package:http/http.dart' as http;

class PenjadwalanService {
  // Mock API untuk imunisasi
  Future<List<Anak>> getAnakList(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConstant.baseUrlApi}/anak/orang-tua/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Anak.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data anak');
    }
  }

  Future<List<JadwalImunisasi>> getJadwalImunisasi(String idAnak) async {
    final response = await http.get(
      Uri.parse('${ApiConstant.baseUrlApi}/imunisasi/$idAnak'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<JadwalImunisasi> jadwalList = [];

      var daftarJadwal = data['jadwal_imunisasi'] as List;
      var daftarDaftar = data['data'] as List;

      for (var daftar in daftarDaftar) {
        String idJadwal = daftar['id_jadwal_imunisasi'];
        var jadwal = daftarJadwal.firstWhere(
          (j) => j['id_jadwal_imunisasi'] == idJadwal,
          orElse: () => null,
        );

        if (jadwal != null) {
          jadwalList.add(
            JadwalImunisasi(
              id: jadwal['id_jadwal_imunisasi'],
              vaksin: "Vaksin ${jadwal['id_jadwal_imunisasi']}",
              usiaPemberian: jadwal['usia_pemberian'],
              tanggal: DateTime.parse(jadwal['tanggal_imunisasi']),
              statusImunisasi: jadwal['status_imunisasi'],
              namaBidan: jadwal['nama_bidan'],
              alamat: jadwal['alamat'],
            ),
          );
        }
      }

      return jadwalList;
    } else {
      throw Exception('Gagal mengambil data jadwal imunisasi');
    }
  }

  Future<List<JadwalPosyandu>> getJadwalPosyandu(String idJenis) async {
    final url = Uri.parse('${ApiConstant.baseUrlApi}/jadwal-posyandu/$idJenis');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<JadwalPosyandu> jadwalList = [];

      var daftar = data['data'] as List;
      String alamat = data['jenis_posyandu']['alamat'];

      for (var item in daftar) {
        var waktuMulai = item['jam_mulai'].split(":");
        var waktuSelesai = item['jam_selesai'].split(":");

        jadwalList.add(
          JadwalPosyandu(
            id: item['id_jadwal_posyandu'],
            kegiatan: item['kegiatan'],
            tanggal: DateTime.parse(item['tanggal']),
            jamMulai: TimeOfDay(
              hour: int.parse(waktuMulai[0]),
              minute: int.parse(waktuMulai[1]),
            ),
            jamSelesai: TimeOfDay(
              hour: int.parse(waktuSelesai[0]),
              minute: int.parse(waktuSelesai[1]),
            ),
            catatan: item['catatan'],
            lokasi: alamat,
          ),
        );
      }

      return jadwalList;
    } else {
      throw Exception('Gagal mengambil data jadwal posyandu');
    }
  }
}
