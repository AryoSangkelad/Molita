import 'package:flutter/material.dart';
import 'package:molita_flutter/core/utils/date_helper.dart';
import 'package:molita_flutter/viewmodels/orang_tua/penjadwalan_viewmodal.dart';
import 'package:molita_flutter/views/orang_tua/Penjadwalan/widgets/detail_jadwal_bottomsheet.dart';

Widget buildImunisasiContent(PenjadwalanViewModal viewModel) {
  final jadwal = viewModel.jadwalImunisasi;

  if (jadwal.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Text(
          'Belum ada jadwal imunisasi untuk anak ini',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  return ListView.separated(
    itemCount: jadwal.length,
    separatorBuilder: (context, index) => SizedBox(height: 10),
    itemBuilder: (context, index) {
      final item = jadwal[index];
      final statusColor = _getStatusColor(item.statusImunisasi);
      final statusTextColor = _getStatusTextColor(item.statusImunisasi);

      return Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewModel.setSelectedItem(item);
            showModalBottomSheet(
              context: context,
              builder: (context) => DetailJadwalBottomSheet(),
              isScrollControlled: true,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.vaccines, size: 32, color: Colors.blueAccent),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaImunisasi,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Usia: ${item.usiaPemberian} bulan',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        'Tanggal: ${DateHelper.formatTanggal(item.tanggal)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(
                    item.statusImunisasi,
                    style: TextStyle(
                      color: statusTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: statusColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Sudah':
      return Colors.green.shade100;
    case 'Tertunda':
      return Colors.orange.shade100;
    case 'Belum':
      return Colors.red.shade100;
    default:
      return Colors.grey.shade200;
  }
}

Color _getStatusTextColor(String status) {
  switch (status) {
    case 'Sudah':
      return Colors.green.shade800;
    case 'Tertunda':
      return Colors.orange.shade800;
    case 'Belum':
      return Colors.red.shade800;
    default:
      return Colors.grey.shade800;
  }
}
