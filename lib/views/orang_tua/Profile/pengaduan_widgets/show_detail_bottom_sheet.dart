import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/pengaduan_model.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_widgets/detail_item.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_widgets/detail_item_html.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_widgets/status_chip.dart';

void showDetailBottomSheet(BuildContext context, Pengaduan item) {
  print(item.lampiranUrl);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Judul + Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.judul,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    buildStatusChip(item.status ?? 'Menunggu'),
                  ],
                ),
                const SizedBox(height: 24),

                // Detail Item
                buildDetailItem(
                  title: 'Kategori',
                  content: item.namaKategori ?? '-',
                ),
                buildDetailItem(
                  title: 'Tanggal',
                  content: formatTanggal(item.createdAt),
                ),
                buildDetailItem(title: 'Deskripsi', content: item.deskripsi),

                // Lampiran
                if (item.lampiranUrl != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Lampiran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "${AppConstant.baseUrlFoto}${item.lampiranUrl!}",
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Tanggapan pakai Html
                buildDetailItemHtml(
                  title: 'Tanggapan',
                  content: item.tanggapan ?? "-",
                  isLast: true,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

String formatTanggal(String? dateStr) {
  if (dateStr == null) return '-';
  try {
    final date = DateTime.parse(dateStr);
    return DateFormat(
      'd MMMM yyyy',
      'id_ID',
    ).format(date); // Contoh: 25 Mei 2025
  } catch (_) {
    return '-';
  }
}
