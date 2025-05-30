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

  // Warna yang lebih kontras untuk pertumbuhan berbeda
  final Color weightColor = const Color(0xFF4361EE);
  final Color heightColor = const Color(0xFF4CAF50);
  final Color secondaryColor = const Color(0xFF3F37C9);
  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<PertumbuhanViewModel>(context, listen: false);

    // Tunda pemanggilan init sampai build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.init(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Grafik Pertumbuhan',
          style: TextStyle(
            color: weightColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<PertumbuhanViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return _buildLoadingState();
          }
          if (model.daftarAnak.isEmpty) {
            return _buildEmptyState();
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnakDropdown(model),
                const SizedBox(height: 24),
                _buildGrafikTabs(model),
                const SizedBox(height: 24),
                Expanded(child: _buildGrafik(model)),
                const SizedBox(height: 24),
                _buildDeskripsi(model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(weightColor),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat data pertumbuhan...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_graph_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Belum ada data anak",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tambahkan data anak untuk melihat grafik pertumbuhan",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAnakDropdown(PertumbuhanViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'PILIH ANAK',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: weightColor,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<Anak>(
            value: model.selectedAnak,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: weightColor),
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            dropdownColor: Colors.white,
            onChanged: (Anak? newValue) {
              if (newValue != null) {
                model.setSelectedAnak(newValue);
              }
            },
            items:
                model.daftarAnak.map((anak) {
                  return DropdownMenuItem<Anak>(
                    value: anak,
                    child: Text(
                      anak.nama,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGrafikTabs(PertumbuhanViewModel model) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromARGB(255, 215, 223, 255), // Warna outline
          width: 1.5, // Ketebalan outline
        ),
      ),
      child: Row(
        children:
            ['Semua', 'Berat Badan', 'Tinggi Badan'].map((jenis) {
              final bool isSelected = jenis == model.selectedGrafik;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => model.setSelectedGrafik(jenis),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? weightColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: weightColor.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      child: Center(
                        child: Text(
                          jenis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart_rounded, color: Colors.grey[300], size: 60),
            const SizedBox(height: 8),
            Text(
              'Belum ada data pertumbuhan',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            top: 20,
            right: 12,
            bottom: 12,
            left: 8,
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getMaxY(model) / 5,
                getDrawingHorizontalLine:
                    (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBorder: BorderSide(color: weightColor),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final date = data[spot.x.toInt()].tanggalPencatatan;
                      final unit = spot.barIndex == 0 ? 'kg' : 'cm';
                      return LineTooltipItem(
                        '${_formatDate(date)}\n${spot.y.toStringAsFixed(1)} $unit',
                        TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }).toList();
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: data.length > 6 ? 2 : 1,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= data.length || value.toInt() < 0) {
                        return const Text('');
                      }
                      final date = data[value.toInt()].tanggalPencatatan;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _formatDate(date, short: data.length > 6),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        "${value.toInt()}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (data.length - 1).toDouble(),
              minY: 0,
              maxY: _getMaxY(model),
              lineBarsData: [
                LineChartBarData(
                  spots: _generateSpots(data, 'berat'),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: weightColor,
                  barWidth: 3,
                  shadow: BoxShadow(
                    color: weightColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter:
                        (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 3,
                          color: weightColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        weightColor.withOpacity(0.2),
                        weightColor.withOpacity(0.01),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                if (model.selectedGrafik == 'Semua')
                  LineChartBarData(
                    spots: _generateSpots(data, 'tinggi'),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: heightColor,
                    barWidth: 3,
                    shadow: BoxShadow(
                      color: heightColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter:
                          (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 3,
                            color: heightColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          heightColor.withOpacity(0.2),
                          heightColor.withOpacity(0.01),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeskripsi(PertumbuhanViewModel model) {
    final data = model.dataPertumbuhan;
    if (data.isEmpty) return const SizedBox();

    String title = '';
    String desc = '';
    IconData icon = Icons.insights_rounded;

    switch (model.selectedGrafik) {
      case 'Semua':
        title = 'Pertumbuhan Komprehensif';
        desc =
            'Perkembangan berat badan dan tinggi badan ${model.selectedAnak?.nama} menunjukkan tren positif. Grafik ini membantu memantau keseimbangan antara pertumbuhan fisik dan perkembangan nutrisi.';
        icon = Icons.bar_chart_rounded;
        break;
      case 'Berat Badan':
        title = 'Perkembangan Berat Badan';
        desc =
            'Pola pertumbuhan berat badan yang stabil menunjukkan asupan nutrisi yang baik. Pertahankan pola makan seimbang untuk menjaga tren positif ini.';
        icon = Icons.monitor_weight_rounded;
        break;
      default:
        title = 'Perkembangan Tinggi Badan';
        desc =
            'Peningkatan tinggi badan yang konsisten mencerminkan perkembangan tulang dan otot yang sehat. Pastikan aktivitas fisik yang cukup dan istirahat teratur.';
        icon = Icons.height_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: weightColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: weightColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, {bool short = false}) {
    return short
        ? '${date.day}/${date.month}'
        : '${date.day} ${_formatBulan(date.month)}';
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
    return bulanList[bulan - 1];
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

    double maxValue = 0;
    if (model.selectedGrafik == 'Semua') {
      maxValue =
          data
              .map((d) => [d.beratBadan, d.tinggiBadan])
              .expand((i) => i)
              .reduce((a, b) => a > b ? a : b) +
          5;
    } else if (model.selectedGrafik == 'Berat Badan') {
      maxValue =
          data.map((d) => d.beratBadan).reduce((a, b) => a > b ? a : b) + 3;
    } else {
      maxValue =
          data.map((d) => d.tinggiBadan).reduce((a, b) => a > b ? a : b) + 5;
    }
    return maxValue.ceilToDouble();
  }
}
