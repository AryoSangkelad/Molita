import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_edukasi_terbaru_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_header_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_informasi_kesehatan_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/build_jadwal_posyandu_widget.dart';
import 'package:molita_flutter/views/orang_tua/Dashboard/widgets/data_anak_widget.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(context, viewModel.username),
                buildJadwalPosyandu(),
                buildDataAnak(viewModel),
                buildEdukasiTerbaru(viewModel),
                buildInformasiKesehatan(viewModel),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
