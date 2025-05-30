import 'package:flutter/material.dart';
import 'package:molita_flutter/core/utils/date_helper.dart';
import 'package:molita_flutter/viewmodels/orang_tua/penjadwalan_viewmodal.dart';
import 'package:molita_flutter/views/orang_tua/Penjadwalan/widgets/detail_jadwal_bottomsheet.dart';

Widget buildPosyanduContent(PenjadwalanViewModal viewModel) {
  final jadwal = viewModel.jadwalPosyandu;

  if (jadwal.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Text(
          'Belum ada jadwal posyandu',
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
                Icon(Icons.local_hospital, size: 32, color: Colors.purple),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.kegiatan,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 6),
                          Text(
                            DateHelper.formatTanggal(item.tanggal),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.place, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              item.lokasi,
                              style: TextStyle(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
