import 'package:flutter/material.dart';
import 'package:molita_flutter/models/orang_tua/jadwal_posyandu.dart';
import 'package:molita_flutter/models/orang_tua/jenis_posyandu_model.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_article_terbaru_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_header_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/video_terbaru_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_jadwal_posyandu_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/data_anak_widget.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  final OrangTua orangTua;
  final JenisPosyandu? jenisPosyandu;
  final JadwalPosyandu? jadwalPosyandu;

  const DashboardView({
    Key? key,
    required this.orangTua,
    this.jenisPosyandu,
    this.jadwalPosyandu,
  }) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final edukasiViewModel = Provider.of<EdukasiViewModel>(
          context,
          listen: false,
        );
        final dashboardViewModel = Provider.of<DashboardViewModel>(
          context,
          listen: false,
        );

        dashboardViewModel.loadData(widget.orangTua.idOrangTua!);
        edukasiViewModel.loadData();
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    final dashboardViewModel = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Header dan spacer
                      Column(
                        children: [
                          buildHeader(context, widget.orangTua),
                          SizedBox(height: 35),
                        ],
                      ),

                      Positioned(
                        top: screenHeight * 0.14,
                        left: 16,
                        right: 16,
                        child: buildJadwalPosyandu(
                          context,
                          widget.jenisPosyandu,
                          widget.jadwalPosyandu,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  buildDataAnak(context, dashboardViewModel),
                  const SizedBox(height: 5),
                  buildArtikelTerbaru(context, dashboardViewModel),
                  const SizedBox(height: 5),
                  buildVideoTerbaru(dashboardViewModel),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chat-bot');
        },
        child: Icon(Icons.support_agent, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
