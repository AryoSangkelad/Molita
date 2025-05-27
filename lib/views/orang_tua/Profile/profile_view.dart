import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/about_app_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/change_password_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/pengaduan_view.dart';
import 'package:molita_flutter/views/orang_tua/Profile/edit_profile_view.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final OrangTua orangTua;
  const ProfileView({super.key, required this.orangTua});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _darkMode = false;
  late Future<void> _orangTuaFuture; // Future untuk menunggu pemuatan data

  final _blueGradient = const LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );

    // Inisialisasi Future untuk memuat data
    _orangTuaFuture = profileViewModel.loadOrangTua(widget.orangTua.idOrangTua);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 16),
                  Text('Terjadi kesalahan: ${snapshot.error}'),
                  TextButton(
                    onPressed: () {
                      // Muat ulang data jika terjadi error
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
                    child: const Text('Coba Lagi'),
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
                              "${AppConstant.baseUrl}storage/${viewModel.orangTua!.img}",
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
                                () =>
                                    _pickImage(viewModel.orangTua?.idOrangTua),
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
                    _buildSectionTitle('Informasi Pribadi'),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      items: [
                        _buildInfoItem(
                          Icons.email_rounded,
                          'Email',
                          viewModel.orangTua!.email ?? '',
                        ),
                        _buildInfoItem(
                          Icons.phone_rounded,
                          'Nomor Telepon',
                          viewModel.orangTua!.noTelepon ?? '',
                        ),
                        _buildInfoItem(
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
                          _buildSettingItem(
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
                          _buildSettingItem(
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
                          _buildSettingItem(
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
                        onPressed: () => _showLogoutDialog(viewModel),
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

  Future<void> _pickImage(String? idOrangTua) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final ProfileViewModel viewModel = Provider.of<ProfileViewModel>(
        context,
        listen: false,
      );
      await viewModel.uploadNewPhoto(idOrangTua!, pickedFile.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Foto berhasil diunggah'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> items}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children:
              items
                  .map(
                    (item) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: item,
                        ),
                        if (item != items.last)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1976D2)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData leadingIcon,
    String title,
    IconData trailingIcon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(leadingIcon, color: Colors.blue[800]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Icon(trailingIcon, size: 14, color: Colors.grey[600]),
      onTap: onTap ?? () => _showSnackBar(context, title),
    );
  }

  void _showLogoutDialog(ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text(
              'Apakah Anda yakin ingin keluar dari akun ini?',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Color(0xFF1976D2)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Berhasil keluar');
                  viewModel.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  shadowColor: Colors.red.shade100,
                ),
                child: const Text(
                  'Ya, Keluar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      ),
    );
  }
}
