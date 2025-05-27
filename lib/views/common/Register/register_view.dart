import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/colors_constant.dart';
import 'package:molita_flutter/viewmodels/orang_tua/register_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  void _register(BuildContext context) async {
    final viewModel = Provider.of<RegisterViewModel>(context, listen: false);
    final username = viewModel.usernameController.text.trim();
    final email = viewModel.emailController.text.trim();
    final password = viewModel.passwordController.text;
    final confirmPassword = viewModel.confirmPasswordController.text;

    // Validasi input
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage(context, 'Semua field wajib diisi');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showMessage(context, 'Format email tidak valid');
      return;
    }

    if (password != confirmPassword) {
      _showMessage(context, 'Password tidak cocok');
      return;
    }

    final message = await viewModel.register();
    _showMessage(context, message ?? 'Pendaftaran gagal');

    if (message != null && message.toLowerCase().contains('berhasil')) {
      // Clear form setelah berhasil
      viewModel.usernameController.clear();
      viewModel.emailController.clear();
      viewModel.passwordController.clear();
      viewModel.confirmPasswordController.clear();

      // Navigasi ke login
      Navigator.pushNamed(context, '/login');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9CCAFF), Color(0xFFD7F1FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: MediaQuery.of(context).size.width * .35,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      "Daftar Akun",
                      style: TextStyle(
                        fontFamily: 'PassionOne',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: ColorsConstant.brightBlue,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Username
                    TextField(
                      controller: viewModel.usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Masukkan Username Anda',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextField(
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Masukkan Email Anda',
                        prefixIcon: const Icon(Icons.email, color: Colors.blue),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: viewModel.passwordController,
                      obscureText: viewModel.isPasswordHidden,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Masukkan Sandi Anda',
                        prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: viewModel.togglePasswordVisibility,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi Password
                    TextField(
                      controller: viewModel.confirmPasswordController,
                      obscureText: viewModel.isConfirmPasswordHidden,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Konfirmasi Sandi Anda',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.isConfirmPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: viewModel.toggleConfirmPasswordVisibility,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            viewModel.loading ? null : () => _register(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child:
                            viewModel.loading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  "Daftar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun?",
                          style: TextStyle(color: Colors.black87),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, '/login'),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      '“ Pantau tumbuh kembang buah hati\n  dengan cinta dan teknologi ”',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.indigo,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
