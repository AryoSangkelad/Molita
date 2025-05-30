import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/show_snackbar.dart';

void showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
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
                showSnackBar(context, 'Berhasil keluar');
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
