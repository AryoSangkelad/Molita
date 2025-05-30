import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/about_app_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/change_password_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/edit_profile_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/info_card.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/info_item.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/logout_dialog.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/pick_image.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/section_title.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/setting_item.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final OrangTua orangTua;
  const ProfileView({super.key, required this.orangTua});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _darkMode = false;
  Future<void>? _orangTuaFuture;

  final _blueGradient = const LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(
        context,
        listen: false,
      );

      setState(() {
        _orangTuaFuture = profileViewModel.loadOrangTua(
          widget.orangTua.idOrangTua,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _blueGradient),
        ),
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EditProfileView(orangTua: widget.orangTua),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _orangTuaFuture, // Menunggu data selesai dimuat
        builder: (context, snapshot) {
          // Tampilkan loading saat data sedang dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan error jika terjadi kesalahan
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 40),
                  SizedBox(height: 16),
                  Text('Terjadi kesalahan: ${snapshot.error}'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        final profileViewModel = Provider.of<ProfileViewModel>(
                          context,
                          listen: false,
                        );
                        _orangTuaFuture = profileViewModel.loadOrangTua(
                          widget.orangTua.idOrangTua,
                        );
                      });
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // Setelah data berhasil dimuat, tampilkan profil
          return Consumer<ProfileViewModel>(
            builder: (context, viewModel, child) {
              // Pastikan data tersedia sebelum diakses
              if (viewModel.orangTua == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: _blueGradient,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              "${AppConstant.baseUrlFoto}${viewModel.orangTua!.img ?? "-"}",
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap:
                                () => pickImage(
                                  context,
                                  viewModel.orangTua?.idOrangTua ?? "-",
                                ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 24,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.orangTua!.username ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Text(
                      viewModel.orangTua!.email ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Info Section
                    buildSectionTitle('Informasi Pribadi'),
                    const SizedBox(height: 16),
                    buildInfoCard(
                      items: [
                        buildInfoItem(
                          Icons.email_rounded,
                          'Email',
                          viewModel.orangTua!.email ?? '',
                        ),
                        buildInfoItem(
                          Icons.phone_rounded,
                          'Nomor Telepon',
                          viewModel.orangTua!.noTelepon ?? '',
                        ),
                        buildInfoItem(
                          Icons.location_on_rounded,
                          'Alamat',
                          viewModel.orangTua!.alamat ?? '',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Pengaturan Akun
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          buildSettingItem(
                            context,
                            Icons.lock,
                            "Keamanan Akun",
                            Icons.arrow_forward_ios,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => KeamananAkunView(
                                        email: viewModel.orangTua!.email ?? '',
                                      ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          buildSettingItem(
                            context,
                            Icons.notifications,
                            "Pengaduan",
                            Icons.arrow_forward_ios,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => PengaduanView(
                                        idOrangTua:
                                            viewModel.orangTua!.idOrangTua ??
                                            "-",
                                      ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          buildSettingItem(
                            context,
                            Icons.info,
                            "Tentang Aplikasi",
                            Icons.arrow_forward_ios,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AboutAppView(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => showLogoutDialog(context, viewModel),
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text(
                          'Keluar Akun',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: Colors.red.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
