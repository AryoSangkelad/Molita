import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molita_flutter/core/constants/app_constant.dart';
import 'package:molita_flutter/models/orang_tua/orang_tua_model.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/edit_profile_widgets/text_field.dart';

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
  late TextEditingController _alamatController;
  late TextEditingController _noTeleponController;
  final _formKey = GlobalKey<FormState>();
  final _primaryColor = const Color(0xFF2196F3);
  final _secondaryColor = const Color(0xFF64B5F6);

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
    _loadData();
    _initializeControllers(widget.orangTua);
  }

  void _initializeControllers(OrangTua orangTua) {
    _namaIbuController = TextEditingController(text: orangTua.namaIbu ?? '');
    _namaAyahController = TextEditingController(text: orangTua.namaAyah ?? '');
    _alamatController = TextEditingController(text: orangTua.alamat ?? '');
    _noTeleponController = TextEditingController(
      text: orangTua.noTelepon ?? '',
    );
  }

  Future<void> _loadData() async {
    await _viewModel.loadOrangTua(widget.orangTua.idOrangTua!);

    if (_viewModel.orangTua != null) {
      _namaIbuController.text = _viewModel.orangTua!.namaIbu ?? '';
      _namaAyahController.text = _viewModel.orangTua!.namaAyah ?? '';
      _alamatController.text = _viewModel.orangTua!.alamat ?? '';
      _noTeleponController.text = _viewModel.orangTua!.noTelepon ?? '';
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant EditProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orangTua.idOrangTua != widget.orangTua.idOrangTua) {
      _loadData();
      _initializeControllers(widget.orangTua);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _viewModel.uploadNewPhoto(
        widget.orangTua.idOrangTua!,
        pickedFile.path,
      );

      setState(() {
        _viewModel.loadOrangTua(widget.orangTua.idOrangTua);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Foto berhasil diunggah'),
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama_ibu': _namaIbuController.text,
        'nama_ayah': _namaAyahController.text,
        'alamat': _alamatController.text,
        'no_telepon': _noTeleponController.text,
      };

      await _viewModel.updateProfileData(widget.orangTua.idOrangTua!, data);

      setState(() {
        _loadData();
        _initializeControllers(widget.orangTua);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil berhasil diperbarui'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaIbuController.dispose();
    _namaAyahController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: Colors.white),
            onPressed: _viewModel.isLoading ? null : _submitForm,
            tooltip: 'Simpan Perubahan',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _primaryColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blue.shade100,
                          backgroundImage: NetworkImage(
                            "${AppConstant.baseUrlFoto}${_viewModel.orangTua?.img ?? widget.orangTua.img}",
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: _viewModel.isLoading ? null : _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                buildTextField('Nama Ibu', _namaIbuController, Icons.person),
                const SizedBox(height: 16),
                buildTextField('Nama Ayah', _namaAyahController, Icons.person),
                const SizedBox(height: 16),
                buildTextField(
                  'Alamat',
                  _alamatController,
                  Icons.home,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                buildTextField(
                  'No. Telepon',
                  _noTeleponController,
                  Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        _viewModel.isLoading
                            ? []
                            : [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                  ),
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      disabledBackgroundColor: Colors.blue.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:
                        _viewModel.isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'SIMPAN PERUBAHAN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
