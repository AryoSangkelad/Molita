import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/lupa_password_viewmodel.dart';
import 'package:molita_flutter/views/common/lupa_password/ganti_password_view.dart';

Widget buildVerifyButton(
  BuildContext context,
  LupaPasswordViewModel viewModel,
  List<TextEditingController> otpControllers,
  String username
) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        final otp = otpControllers.map((e) => e.text).join();

        if (otp.length < 4) {
          _showSnackbar(context, 'Harap isi kode OTP lengkap');
          return;
        }

        final isValid = await viewModel.verifikasiOtp(username, otp);
        if (isValid) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GantiPasswordView(username: username),
            ),
          );
        } else {
          _showSnackbar(context, 'OTP tidak valid atau kedaluwarsa');
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
      child: const Text(
        'Verifikasi',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
