import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_article_terbaru_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_header_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/video_terbaru_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_jadwal_posyandu_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/data_anak_widget.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
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

    final edukasiViewModel = Provider.of<EdukasiViewModel>(context);

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
                          buildHeader(context, viewModel.username),
                          SizedBox(height: screenHeight * 0.10),
                        ],
                      ),

                      Positioned(
                        top: screenHeight * 0.15,
                        left: 16,
                        right: 16,
                        child: buildJadwalPosyandu(context),
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
                  buildDataAnak(context),
                  const SizedBox(height: 5),
                  buildArtikelTerbaru(context, edukasiViewModel),
                  const SizedBox(height: 5),
                  buildVideoTerbaru(edukasiViewModel),
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
