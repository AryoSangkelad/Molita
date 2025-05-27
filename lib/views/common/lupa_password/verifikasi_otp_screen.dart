import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/lupa_password_viewmodel.dart';
import 'package:molita_flutter/views/common/lupa_password/ganti_password_screen.dart';
import 'package:provider/provider.dart';

class VerifikasiOtpScreen extends StatelessWidget {
  final String username;
  final String email;

  VerifikasiOtpScreen({Key? key, required this.username, required this.email})
    : super(key: key);

  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LupaPasswordViewModel>(context);

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: SizedBox()), // Spacer atas
                Column(
                  children: [
                    Image.asset(
                      'assets/images/l_otp.png',
                      height: 270,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Verifikasi OTP',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'kode sudah dikirim ke Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(208, 25, 118, 210),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 56,
                          height: 56,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: const Color.fromARGB(
                                255,
                                208,
                                232,
                                255,
                              ),
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 2, 125, 162),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 2, 125, 162),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_focusNodes[index - 1]);
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                const Expanded(child: SizedBox()), // Spacer bawah
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final otp = _otpControllers.map((e) => e.text).join();
                      if (otp.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harap isi kode OTP lengkap'),
                          ),
                        );
                        return;
                      }

                      final isValid = await viewModel.verifikasiOtp(
                        username,
                        otp,
                      );
                      if (isValid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => GantiPasswordScreen(username: username),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('OTP tidak valid atau kedaluwarsa'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                ),
                const SizedBox(height: 14),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ingat Password anda?",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
