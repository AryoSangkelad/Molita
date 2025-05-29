// services/schedule_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_imunisasi.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';
import 'package:http/http.dart' as http;

class PenjadwalanService {
  // Mock API untuk imunisasi
  Future<List<Anak>> getAnakList(String userId) async {
    final response = await http.get(
      Uri.parse('${AppConstant.baseUrlApi}/anak/orang-tua/$userId'),
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
      Uri.parse('${AppConstant.baseUrlApi}/imunisasi/$idAnak'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<JadwalImunisasi> jadwalList = [];

      var daftarJadwal = data['jadwal_imunisasi'] as List;
      var daftarDaftar = data['data'] as List;

      for (var daftar in daftarDaftar) {
        String idJadwal = daftar['id_jadwal_imunisasi'] ?? '';

        var jadwal = daftarJadwal.firstWhere(
          (j) => j['id_jadwal_imunisasi'] == idJadwal,
          orElse: () => null,
        );

        if (jadwal != null) {
          try {
            jadwalList.add(
              JadwalImunisasi(
                id: jadwal['id_jadwal_imunisasi'] ?? '',
                namaImunisasi: "${jadwal['nama_imunisasi'] ?? '-'}",
                usiaPemberian:
                    jadwal['usia_pemberian'] != null
                        ? (jadwal['usia_pemberian'] is int
                            ? jadwal['usia_pemberian']
                            : int.tryParse(
                                  jadwal['usia_pemberian'].toString(),
                                ) ??
                                0)
                        : 0,
                tanggal:
                    jadwal['tanggal_imunisasi'] != null
                        ? DateTime.parse(jadwal['tanggal_imunisasi'])
                        : DateTime.now(),
                statusImunisasi: jadwal['status_imunisasi'] ?? '-',
                namaBidan: jadwal['nama_bidan'] ?? '-',
                alamat: jadwal['alamat'] ?? '-',
              ),
            );
          } catch (e) {
            print('Gagal parsing jadwal imunisasi: $e');
          }
        }
      }

      return jadwalList;
    } else {
      throw Exception('Gagal mengambil data jadwal imunisasi');
    }
  }

  Future<List<JadwalPosyandu>> getJadwalPosyandu(String idJenis) async {
    final url = Uri.parse('${AppConstant.baseUrlApi}/jadwal-posyandu/$idJenis');
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

  Future<JadwalPosyandu?> getJadwalTerdekat(String idJenis) async {
    final url = Uri.parse('${AppConstant.baseUrlApi}/jadwal-terdekat/$idJenis');
    final response = await http.get(url);

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final item = data['data'];

      if (item == null) {
        return null; // tidak ada jadwal
      }

      String alamat = data['jenis_posyandu']?['alamat'] ?? '-';

      String jamMulaiStr = item['jam_mulai'] ?? '00:00';
      String jamSelesaiStr = item['jam_selesai'] ?? '00:00';

      List<String> waktuMulai = jamMulaiStr.split(":");
      List<String> waktuSelesai = jamSelesaiStr.split(":");

      return JadwalPosyandu(
        id: item['id_jadwal_posyandu'] ?? '',
        kegiatan: item['kegiatan'] ?? '-',
        tanggal:
            item['tanggal'] != null
                ? DateTime.tryParse(item['tanggal']) ?? DateTime.now()
                : DateTime.now(),
        jamMulai: TimeOfDay(
          hour: int.tryParse(waktuMulai[0]) ?? 0,
          minute: int.tryParse(waktuMulai[1]) ?? 0,
        ),
        jamSelesai: TimeOfDay(
          hour: int.tryParse(waktuSelesai[0]) ?? 0,
          minute: int.tryParse(waktuSelesai[1]) ?? 0,
        ),
        catatan: item['catatan'] ?? '-',
        lokasi: alamat,
      );
    } else if (response.statusCode == 404) {
      return null; // anggap tidak ada jadwal
    } else {
      throw Exception('Gagal mengambil jadwal posyandu terdekat');
    }
  }
}
