import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/lupa_password_viewmodel.dart';
import 'package:molita_flutter/views/common/lupa_password/verifikasi_otp_view.dart';
import 'package:provider/provider.dart';

class LupaPasswordView extends StatelessWidget {
  const LupaPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LupaPasswordViewModel>(context);
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/l_lupa_sandi.png', // ganti path sesuai file asset
                    height: 270,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lupa Sandi',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700], // Sama seperti primaryColor
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masukkan email dan nomor Anda\nuntuk mengatur ulang kata sandi.',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(208, 25, 118, 210),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 208, 232, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 2, 125, 162),
                        ),
                        hintText: 'Username....',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 2, 125, 162),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 2, 125, 162),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 208, 232, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 2, 125, 162),
                        ),
                        hintText: 'Alamat Email....',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 2, 125, 162),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 2, 125, 162),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  viewModel.isLoading
                      ? CircularProgressIndicator(color: Colors.blue[700])
                      : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final username = usernameController.text.trim();
                            final email = emailController.text.trim();

                            if (username.isEmpty || email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Harap isi semua field'),
                                  backgroundColor: Colors.blue[500],
                                ),
                              );
                              return;
                            }

                            await viewModel.kirimOtp(username, email);

                            if (viewModel.message.toLowerCase().contains(
                              'kode otp telah dikirim',
                            )) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => VerifikasiOtpView(
                                        username: username,
                                        email: email,
                                      ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(viewModel.message),
                                  backgroundColor: Colors.blue[500],
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Ingat Password anda? ',
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'Masuk',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
