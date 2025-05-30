import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/detail_anak_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Anak/widgets/empty_state.dart';
import 'package:molita_flutter/views/orang_tua/Anak/widgets/error_state.dart';
import 'package:molita_flutter/views/orang_tua/Anak/widgets/info_item.dart';
import 'package:molita_flutter/views/orang_tua/Anak/widgets/info_section.dart';
import 'package:molita_flutter/views/orang_tua/Anak/widgets/profile_header.dart';
import 'package:molita_flutter/views/orang_tua/Anak/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailAnakView extends StatelessWidget {
  const DetailAnakView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Anak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<DetailAnakViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return buildShimmerLoading();
          }

          if (viewModel.errorMessage != null) {
            return buildErrorState(viewModel.errorMessage!);
          }

          final anak = viewModel.anak;
          if (anak == null) {
            return buildEmptyState();
          }

          final dateFormat = DateFormat('dd MMMM yyyy');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                buildProfileHeader(anak.nama),
                const SizedBox(height: 24),
                buildInfoSection(
                  icon: Icons.fingerprint,
                  title: "Identitas Anak",
                  color: Colors.blue,
                  children: [
                    buildInfoItem("Nama Lengkap", anak.nama),
                    buildInfoItem(
                      "Tanggal Lahir",
                      dateFormat.format(anak.tanggalLahir!),
                    ),
                    buildInfoItem("Jenis Kelamin", anak.jenisKelamin),
                  ],
                ),
                const SizedBox(height: 20),
                buildInfoSection(
                  icon: Icons.location_pin,
                  title: "Alamat",
                  color: Colors.green,
                  children: [
                    buildInfoItem("Alamat", anak.alamat),
                    if (anak.desa != null)
                      buildInfoItem("Desa/Kelurahan", anak.desa!.nama),
                    if (anak.desa?.kecamatan != null)
                      buildInfoItem("Kecamatan", anak.desa!.kecamatan.nama),
                    if (anak.desa?.kecamatan.kota != null)
                      buildInfoItem(
                        "Kota/Kabupaten",
                        anak.desa!.kecamatan.kota.nama,
                      ),
                    if (anak.desa?.kecamatan.kota.provinsi != null)
                      buildInfoItem(
                        "Provinsi",
                        anak.desa!.kecamatan.kota.provinsi.nama,
                      ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
