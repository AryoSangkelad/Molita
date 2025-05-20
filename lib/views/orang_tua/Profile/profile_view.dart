import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/edit_profile_view.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final OrangTua? orangTua;
  const ProfileView({super.key, required this.orangTua});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    ProfileViewModel viewModel = Provider.of<ProfileViewModel>(context);

    Future<void> _pickImage(String? idOrangTua) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        await viewModel.uploadNewPhoto(idOrangTua!, pickedFile.path);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Foto berhasil diunggah')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue[800]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EditProfileView(orangTua: widget.orangTua!),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    "${ApiConstant.baseUrl}storage/${widget.orangTua!.img}",
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue[800]!, width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: InkWell(
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.blue[800],
                    ),
                    onTap: () {
                      _pickImage(widget.orangTua?.idOrangTua);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              widget.orangTua!.username ?? '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.orangTua!.email ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 20),

            // Info Cards
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informasi Pribadi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(
                      Icons.email,
                      "Email",
                      widget.orangTua!.email ?? '',
                    ),
                    Divider(),
                    _buildInfoRow(
                      Icons.phone,
                      "Nomor Telepon",
                      widget.orangTua!.noTelepon ?? '',
                    ),
                    Divider(),
                    _buildInfoRow(Icons.cake, "Tanggal Lahir", "15 Mei 2000"),
                    Divider(),
                    _buildInfoRow(
                      Icons.location_on,
                      "Lokasi",
                      widget.orangTua!.alamat ?? '',
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Account Settings
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
                  ),
                  Divider(height: 1),
                  _buildSettingItem(
                    Icons.notifications,
                    "Pengaduan",
                    Icons.arrow_forward_ios,
                  ),
                  Divider(height: 1),
                  _buildSettingItem(
                    Icons.info,
                    "Tentang Aplikasi",
                    Icons.arrow_forward_ios,
                  ),
                  Divider(height: 1),
                  _buildSettingItem(
                    Icons.language,
                    "Bahasa",
                    Icons.arrow_forward_ios,
                  ),
                  Divider(height: 1),
                  SwitchListTile(
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                    },
                    title: Row(
                      children: [
                        Icon(Icons.dark_mode, color: Colors.blue[800]),
                        SizedBox(width: 12),
                        Text("Dark Mode"),
                      ],
                    ),
                    activeColor: Colors.blue[800],
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Logout Button (Full Width & Outline)
            SizedBox(
              width: double.infinity, // agar tombol selebar layar
              child: OutlinedButton.icon(
                onPressed: _showLogoutDialog,
                icon: Icon(Icons.logout, size: 20, color: Colors.red[400]),
                label: Text("Keluar", style: TextStyle(color: Colors.red[400])),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.red[400]!,
                    width: 2,
                  ), // outline merah
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue[800]),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData leadingIcon,
    String title,
    IconData trailingIcon,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(leadingIcon, color: Colors.blue[800]),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(trailingIcon, size: 14, color: Colors.grey[600]),
      onTap: () {
        _showSnackBar(context, title);
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Konfirmasi Keluar"),
            content: Text("Apakah Anda yakin ingin keluar dari akun ini?"),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text("Batal", style: TextStyle(color: Colors.blue[800])),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSnackBar(context, "Berhasil keluar");
                  // Implementasi logout logic di sini
                },
                child: Text(
                  "Ya, Keluar",
                  style: TextStyle(color: Colors.red[400]),
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
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
