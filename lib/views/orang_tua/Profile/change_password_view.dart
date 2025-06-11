import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/colors_constant.dart';
import 'package:molita_flutter/viewmodels/orang_tua/password_viewmodel.dart';
import 'package:molita_flutter/views/orang_tua/Profile/change_password_widgets/password_field.dart';
import 'package:provider/provider.dart';

class KeamananAkunView extends StatefulWidget {
  final String email;
  const KeamananAkunView({super.key, required this.email});

  @override
  State<KeamananAkunView> createState() => _KeamananAkunViewState();
}

class _KeamananAkunViewState extends State<KeamananAkunView> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final passwordVM = Provider.of<PasswordViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keamanan Akun"),
        backgroundColor: ColorsConstant.brightBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ganti Password',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorsConstant.brightBlue,
                          ),
                        ),
                        const SizedBox(height: 24),

                        buildPasswordField(
                          context,
                          confirmPasswordController: confirmPasswordController,
                          currentPasswordController: currentPasswordController,
                          newPasswordController: newPasswordController,
                          controller: currentPasswordController,
                          label: 'Password Saat Ini',
                          hint: 'Masukkan password Anda yang sekarang',
                          icon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 20),

                        buildPasswordField(
                          context,
                          confirmPasswordController: confirmPasswordController,
                          currentPasswordController: currentPasswordController,
                          newPasswordController: newPasswordController,
                          controller: newPasswordController,
                          label: 'Password Baru',
                          hint: 'Masukkan password baru (min. 6 karakter)',
                          icon: Icons.lock_reset,
                        ),
                        const SizedBox(height: 20),

                        buildPasswordField(
                          context,
                          confirmPasswordController: confirmPasswordController,
                          currentPasswordController: currentPasswordController,
                          newPasswordController: newPasswordController,
                          controller: confirmPasswordController,
                          label: 'Konfirmasi Password Baru',
                          hint: 'Ulangi password baru Anda',
                          icon: Icons.lock_clock_outlined,
                        ),
                        const SizedBox(height: 32),

                        if (passwordVM.isLoading)
                          Center(
                            child: Column(
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 12),
                                Text(
                                  'Memproses perubahan...',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.disabledColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsConstant.brightBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'SIMPAN PERUBAHAN',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 1.2,
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
          },
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final passwordVM = Provider.of<PasswordViewModel>(context, listen: false);
    final result = await passwordVM.gantiPassword(
      email: widget.email,
      passwordLama: currentPasswordController.text,
      passwordBaru: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    final snackBar = SnackBar(
      content: Text(
        passwordVM.message ?? (result ? 'Berhasil diperbarui' : 'Error'),
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: result ? Colors.green : Colors.red,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (result) {
      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }
}
