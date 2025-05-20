import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pertumbuhan_viewmodel.dart';
import 'package:molita_flutter/models/orang_tua/anak_model.dart';
import 'package:molita_flutter/models/orang_tua/pertumbuhan_model.dart';

class GrafikView extends StatefulWidget {
  final String userId;
  const GrafikView({Key? key, required this.userId}) : super(key: key);

  @override
  State<GrafikView> createState() => _GrafikViewState();
}

class _GrafikViewState extends State<GrafikView> {
  late PertumbuhanViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<PertumbuhanViewModel>(context, listen: false);
    viewModel.init(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Grafik Pertumbuhan',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // Hilangkan tombol back
      ),
      body: Consumer<PertumbuhanViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue[800]),
            );
          }

          if (model.daftarAnak.isEmpty) {
            return Center(
              child: Text(
                "Belum ada data anak",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown Pilih Anak
                _buildAnakDropdown(model),

                SizedBox(height: 16),

                // Tab Grafik
                _buildGrafikTabs(model),

                SizedBox(height: 16),

                // Grafik
                Expanded(child: _buildGrafik(model)),

                SizedBox(height: 16),

                // Deskripsi
                _buildDeskripsi(model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnakDropdown(PertumbuhanViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Anak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<Anak>(
            value: model.selectedAnak,
            isExpanded: true,
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.blue[800]),
            style: TextStyle(color: Colors.black, fontSize: 14),
            onChanged: (Anak? newValue) {
              if (newValue != null) {
                model.setSelectedAnak(newValue);
              }
            },
            items:
                model.daftarAnak.map((anak) {
                  return DropdownMenuItem<Anak>(
                    value: anak,
                    child: Text(anak.nama),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGrafikTabs(PertumbuhanViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            ['Semua', 'Berat Badan', 'Tinggi Badan'].map((jenis) {
              final bool isSelected = jenis == model.selectedGrafik;
              return Expanded(
                child: GestureDetector(
                  onTap: () => model.setSelectedGrafik(jenis),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[100] : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        jenis,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isSelected ? Colors.blue[800] : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildGrafik(PertumbuhanViewModel model) {
    final data = model.dataPertumbuhan;
    if (data.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data pertumbuhan',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Validasi data
                  if (data.isEmpty ||
                      value.toInt() >= data.length ||
                      value.toInt() < 0) {
                    return Text(''); // Jika indeks tidak valid
                  }

                  final tanggal = data[value.toInt()].tanggalPencatatan;
                  final bulan = _formatBulan(tanggal.month);
                  final tahun = tanggal.year;

                  return Text(
                    '$bulan $tahun',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "${value.toInt()}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[300]!),
          ),
          minX: 0,
          maxX: data.length - 1.toDouble(),
          minY: 0,
          maxY: _getMaxY(model),
          lineBarsData: [
            LineChartBarData(
              spots: _generateSpots(data, 'berat'),
              isCurved: true,
              color: Colors.blue[800]!,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
            if (model.selectedGrafik == 'Semua')
              LineChartBarData(
                spots: _generateSpots(data, 'tinggi'),
                isCurved: true,
                color: Colors.orange[800]!,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.orange.withOpacity(0.2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots(List<Pertumbuhan> data, String jenis) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      Pertumbuhan item = entry.value;
      double yValue = jenis == 'berat' ? item.beratBadan : item.tinggiBadan;
      return FlSpot(index.toDouble(), yValue);
    }).toList();
  }

  double _getMaxY(PertumbuhanViewModel model) {
    final data = model.dataPertumbuhan;
    if (data.isEmpty) return 15;

    if (model.selectedGrafik == 'Semua') {
      return data
              .map((d) => [d.beratBadan, d.tinggiBadan])
              .expand((i) => i)
              .reduce((a, b) => a > b ? a : b) +
          2;
    } else if (model.selectedGrafik == 'Berat Badan') {
      return data.map((d) => d.beratBadan).reduce((a, b) => a > b ? a : b) + 2;
    } else {
      return data.map((d) => d.tinggiBadan).reduce((a, b) => a > b ? a : b) + 2;
    }
  }

  Widget _buildDeskripsi(PertumbuhanViewModel model) {
    final data = model.dataPertumbuhan;
    if (data.isEmpty) return SizedBox();

    String deskripsi = '';
    if (model.selectedGrafik == 'Semua') {
      deskripsi =
          'Grafik menunjukkan pertumbuhan berat badan dan tinggi badan ${model.selectedAnak?.nama} secara keseluruhan. Perkembangan terlihat konsisten dengan peningkatan yang bertahap.';
    } else if (model.selectedGrafik == 'Berat Badan') {
      deskripsi =
          'Berat badan ${model.selectedAnak?.nama} meningkat secara bertahap, menunjukkan pertumbuhan yang sehat sesuai tahap perkembangannya.';
    } else {
      deskripsi =
          'Tinggi badan ${model.selectedAnak?.nama} bertambah secara konsisten, menunjukkan perkembangan fisik yang baik.';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          deskripsi,
          style: TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 13),
        ),
      ),
    );
  }

  String _formatBulan(int bulan) {
    final List<String> bulanList = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return bulanList[bulan - 1]; // Karena bulan dimulai dari 1 (Januari)
  }
}
