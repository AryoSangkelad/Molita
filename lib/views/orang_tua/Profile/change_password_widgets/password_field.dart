import 'package:flutter/material.dart';

Widget buildPasswordField(
  BuildContext context, {
  required TextEditingController currentPasswordController,
  required TextEditingController newPasswordController,
  required TextEditingController confirmPasswordController,
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
}) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.primaryColorDark,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: theme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: theme.textTheme.bodyMedium,
        validator: (value) {
          if (controller == currentPasswordController && value!.isEmpty) {
            return 'Password saat ini wajib diisi';
          }
          if (controller == newPasswordController) {
            if (value!.length < 6) return 'Password minimal 6 karakter';
            if (value == currentPasswordController.text) {
              return 'Password baru harus berbeda';
            }
          }
          if (controller == confirmPasswordController &&
              value != newPasswordController.text) {
            return 'Konfirmasi password tidak cocok';
          }
          return null;
        },
      ),
    ],
  );
}
