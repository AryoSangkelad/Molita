import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_imunisasi.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';
import 'package:molita_flutter/viewmodels/orang_tua/penjadwalan_viewmodal.dart';
import 'package:provider/provider.dart';

class DetailJadwalBottomSheet extends StatelessWidget {
  const DetailJadwalBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PenjadwalanViewModal>(context);
    final item = viewModel.selectedItem;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Text(
              "Detail Jadwal",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (item is JadwalImunisasi) ..._buildImunisasiDetail(item),
            if (item is JadwalPosyandu) ..._buildPosyanduDetail(item),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: Colors.white),
                label: Text("Tutup"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Ganti dengan warna sesuai tema
                  foregroundColor: Colors.white, // Warna teks dan ikon
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildImunisasiDetail(JadwalImunisasi item) {
    return [
      _infoTile(Icons.vaccines, "Imunisasi", item.namaImunisasi),
      _infoTile(Icons.cake, "Usia", "${item.usiaPemberian} bulan"),
      _infoTile(Icons.calendar_today, "Tanggal", _formatTanggal(item.tanggal)),
      _infoTile(Icons.verified, "Status", item.statusImunisasi),
      _infoTile(Icons.person, "Bidan", item.namaBidan),
      _infoTile(Icons.location_on, "Alamat", item.alamat),
    ];
  }

  List<Widget> _buildPosyanduDetail(JadwalPosyandu item) {
    return [
      _infoTile(Icons.event, "Kegiatan", item.kegiatan),
      _infoTile(Icons.calendar_today, "Tanggal", _formatTanggal(item.tanggal)),
      _infoTile(
        Icons.access_time,
        "Waktu",
        "${_formatWaktu(item.jamMulai)} - ${_formatWaktu(item.jamSelesai)}",
      ),
      _infoTile(Icons.place, "Lokasi", item.lokasi),
      _infoTile(Icons.note, "Catatan", item.catatan),
    ];
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                (icon == Icons.note)
                    ? Html(
                      data: value,
                      style: {
                        "body": Style(
                          fontSize: FontSize(16),
                          color: Colors.grey[800],
                          margin: Margins.all(0),
                          padding: HtmlPaddings.all(0),
                        ),
                      },
                    )
                    : Text(value, style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _formatWaktu(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
