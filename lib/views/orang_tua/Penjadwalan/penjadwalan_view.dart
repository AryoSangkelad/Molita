import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/penjadwalan_viewmodal.dart';
import 'package:molita_flutter/views/orang_tua/Penjadwalan/widgets/detail_jadwal_bottomsheet.dart';
import 'package:provider/provider.dart';

class PenjadwalanView extends StatefulWidget {
  final String idOrangTua;
  final String idjenisPosyandu;
  const PenjadwalanView({
    Key? key,
    required this.idOrangTua,
    required this.idjenisPosyandu,
  }) : super(key: key);

  @override
  State<PenjadwalanView> createState() => _PenjadwalanViewState();
}

class _PenjadwalanViewState extends State<PenjadwalanView> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final viewModel = Provider.of<PenjadwalanViewModal>(
          context,
          listen: false,
        );
        viewModel.init(widget.idOrangTua);
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PenjadwalanViewModal>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox(),
        leadingWidth: 10,
        title: Text(
          'Penjadwalan',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Jadwal...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Jenis Jadwal
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    viewModel.scheduleTypes.map((type) {
                      final bool isSelected =
                          type == viewModel.selectedScheduleType;
                      return Expanded(
                        child: GestureDetector(
                          onTap:
                              () => viewModel.setSelectedScheduleType(
                                type,
                                widget.idjenisPosyandu,
                              ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.blue[100]
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  type == 'imunisasi'
                                      ? Icons.child_care
                                      : Icons.local_hospital,
                                  size: 18,
                                  color:
                                      isSelected
                                          ? Colors.blue[800]
                                          : Colors.grey[600],
                                ),
                                SizedBox(width: 6),
                                Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isSelected
                                            ? Colors.blue[800]
                                            : Colors.grey[600],
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Dropdown Pilih Anak (jika pilih imunisasi)
            if (viewModel.selectedScheduleType == 'imunisasi') ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue[800], size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Pilih Anak:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<Anak>(
                          value: viewModel.selectedAnak,
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue[800],
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          onChanged: (Anak? newValue) {
                            if (newValue != null) {
                              viewModel.setSelectedAnak(newValue);
                            }
                          },
                          items:
                              viewModel.daftarAnak.map<DropdownMenuItem<Anak>>((
                                Anak value,
                              ) {
                                return DropdownMenuItem<Anak>(
                                  value: value,
                                  child: Text(value.nama),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            // Konten Jadwal
            if (viewModel.isLoading)
              Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child:
                    viewModel.selectedScheduleType == 'imunisasi'
                        ? _buildImunisasiContent(viewModel)
                        : _buildPosyanduContent(viewModel),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _buildImunisasiContent(PenjadwalanViewModal viewModel) {
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
            _showDetailBottomSheet(context);
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
                        item.vaksin,
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
                        'Tanggal: ${_formatTanggal(item.tanggal)}',
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

Widget _buildPosyanduContent(PenjadwalanViewModal viewModel) {
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
            _showDetailBottomSheet(context);
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
                            _formatTanggal(item.tanggal),
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

void _showDetailBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => DetailJadwalBottomSheet(),
    isScrollControlled: true,
  );
}

String _formatTanggal(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
