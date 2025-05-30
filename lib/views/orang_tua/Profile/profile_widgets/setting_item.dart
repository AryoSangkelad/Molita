import 'package:flutter/material.dart';
import 'package:molita_flutter/views/orang_tua/Profile/profile_widgets/show_snackbar.dart';

Widget buildSettingItem(
  BuildContext context,
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
    onTap: onTap ?? () => showSnackBar(context, title),
  );
}
