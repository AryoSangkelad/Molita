import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molita_flutter/core/constants/api_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  final OrangTua orangTua;
  const EditProfileView({super.key, required this.orangTua});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late ProfileViewModel _viewModel;
  late TextEditingController _namaIbuController;
  late TextEditingController _namaAyahController;
  late TextEditingController _nikIbuController;
  late TextEditingController _nikAyahController;
  late TextEditingController _alamatController;
  late TextEditingController _noTeleponController;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
    _viewModel.setOrangTua(widget.orangTua);

    _namaIbuController = TextEditingController(text: widget.orangTua.namaIbu);
    _namaAyahController = TextEditingController(text: widget.orangTua.namaAyah);
    _nikIbuController = TextEditingController(text: widget.orangTua.nikIbu);
    _nikAyahController = TextEditingController(text: widget.orangTua.nikAyah);
    _alamatController = TextEditingController(text: widget.orangTua.alamat);
    _noTeleponController = TextEditingController(
      text: widget.orangTua.noTelepon,
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _viewModel.uploadNewPhoto(
        widget.orangTua.idOrangTua!,
        pickedFile.path,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Foto berhasil diunggah')));
    }
  }

  Future<void> _submitForm() async {
    if (_validateForm()) {
      final data = {
        'nama_ibu': _namaIbuController.text,
        'nama_ayah': _namaAyahController.text,
        'nik_ibu': _nikIbuController.text,
        'nik_ayah': _nikAyahController.text,
        'alamat': _alamatController.text,
        'no_telepon': _noTeleponController.text,
      };
      await _viewModel.updateProfileData(widget.orangTua.idOrangTua!, data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    }
  }

  bool _validateForm() {
    // Add validation logic here
    return true; // Return true if valid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blue[800], // Primary color
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _submitForm),
        ],
      ),
      body: Container(
        color: Colors.grey[100], // Background color
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Foto Profil
            Card(
              elevation: 4,
              color: Colors.white, // Card background color
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          "${ApiConstant.baseUrl}storage/${widget.orangTua.img}",
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _pickImage,
                            iconSize: 18,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Form Fields
            _buildTextField('Nama Ibu', _namaIbuController),
            _buildTextField('Nama Ayah', _namaAyahController),
            _buildTextField('NIK Ibu', _nikIbuController),
            _buildTextField('NIK Ayah', _nikAyahController),
            _buildTextField('Alamat', _alamatController),
            _buildTextField('No. Telepon', _noTeleponController),

            const SizedBox(height: 30),

            _viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Simpan Perubahan'),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white, // Text field background color
        ),
      ),
    );
  }
}
