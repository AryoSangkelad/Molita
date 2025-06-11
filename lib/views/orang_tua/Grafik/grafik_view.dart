import 'package:flutter/material.dart';
import 'package:molita_flutter/views/orang_tua/Anak/widgets/empty_state.dart';
import 'package:molita_flutter/views/orang_tua/Grafik/widgets/anak_dropdown.dart';
import 'package:molita_flutter/views/orang_tua/Grafik/widgets/grafik.dart';
import 'package:molita_flutter/views/orang_tua/Grafik/widgets/grafik_tabs.dart';
import 'package:molita_flutter/views/orang_tua/Grafik/widgets/loading_state.dart';
import 'package:provider/provider.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pertumbuhan_viewmodel.dart';

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
            return buildLoadingState(weightColor);
          }
          if (model.daftarAnak.isEmpty) {
            return buildEmptyState();
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAnakDropdown(model, weightColor),
                  const SizedBox(height: 24),
                  buildGrafikTabs(model, weightColor),
                  const SizedBox(height: 24),
                  SizedBox(
                    height:
                        300, // Batas tinggi grafik, sesuaikan sesuai kebutuhan
                    child: buildGrafik(model, weightColor, heightColor),
                  ),
                  const SizedBox(height: 24),
                  _buildDeskripsi(model),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeskripsi(PertumbuhanViewModel model) {
    final data = model.dataPertumbuhan;
    if (data.isEmpty) return const SizedBox();

    String title = '';
    IconData icon = Icons.insights_rounded;

    switch (model.selectedGrafik) {
      case 'Semua':
        title = 'Pertumbuhan Komprehensif';
        icon = Icons.bar_chart_rounded;
        break;
      case 'Berat Badan':
        title = 'Perkembangan Berat Badan';
        icon = Icons.monitor_weight_rounded;
        break;
      default:
        title = 'Perkembangan Tinggi Badan';
        icon = Icons.height_rounded;
    }

    String desc =
        model.isLoadingDeskripsi
            ? 'Sedang membuat deskripsi otomatis...'
            : (model.deskripsiGrafik.isNotEmpty
                ? model.deskripsiGrafik
                : 'Belum ada deskripsi tersedia.');

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
}
