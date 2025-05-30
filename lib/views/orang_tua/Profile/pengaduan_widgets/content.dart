import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pengaduan_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_widgets/show_detail_bottom_sheet.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_widgets/status_chip.dart';

Widget buildContent(BuildContext context, PengaduanViewModel pengaduanVM) {
  if (pengaduanVM.isLoading) {
    return Center(child: CircularProgressIndicator());
  }

  if (pengaduanVM.pengaduanList.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Belum ada pengaduan',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Tekan tombol di bawah untuk membuat pengaduan baru',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  return ListView.separated(
    padding: EdgeInsets.all(16),
    physics: BouncingScrollPhysics(),
    itemCount: pengaduanVM.pengaduanList.length,
    separatorBuilder: (_, __) => SizedBox(height: 12),
    itemBuilder: (context, index) {
      final item = pengaduanVM.pengaduanList[index];
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showDetailBottomSheet(context, item),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.judul,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  buildStatusChip(item.status ?? 'Menunggu'),
                ],
              ),
              SizedBox(height: 8),
              Text(
                item.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], height: 1.4),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4),
                  Text(
                    item.namaKategori ?? '-',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    formatTanggal(item.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
