import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/pertumbuhan_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pertumbuhan_viewmodel.dart';

Widget buildGrafik(PertumbuhanViewModel model, Color weightColor, Color heightColor) {
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
        padding: const EdgeInsets.only(top: 20, right: 12, bottom: 12, left: 8),
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
