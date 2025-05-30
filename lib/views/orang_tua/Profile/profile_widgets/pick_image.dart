import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';
import 'package:provider/provider.dart';

Future<void> pickImage(BuildContext context, String? idOrangTua) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final ProfileViewModel viewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );

    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunggah foto: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
