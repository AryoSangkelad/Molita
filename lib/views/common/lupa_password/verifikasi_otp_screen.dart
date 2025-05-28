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

  static const _otpBoxSize = 56.0;
  static const _otpBoxColor = Color.fromARGB(255, 208, 232, 255);
  static const _otpTextColor = Color.fromARGB(255, 2, 125, 162);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LupaPasswordViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
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
                    color: Color.fromARGB(208, 25, 118, 210),
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
                _buildOtpInputs(context),
                const SizedBox(height: 46),
                _buildVerifyButton(context, viewModel),
                const SizedBox(height: 14),
                _buildLoginRedirect(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInputs(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: _otpBoxSize,
          height: _otpBoxSize,
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: _otpBoxColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: _otpTextColor),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton(
    BuildContext context,
    LupaPasswordViewModel viewModel,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final otp = _otpControllers.map((e) => e.text).join();

          if (otp.length < 4) {
            _showSnackbar(context, 'Harap isi kode OTP lengkap');
            return;
          }

          final isValid = await viewModel.verifikasiOtp(username, otp);
          if (isValid) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GantiPasswordScreen(username: username),
              ),
            );
          } else {
            _showSnackbar(context, 'OTP tidak valid atau kedaluwarsa');
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
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Ingat Password anda?", style: TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, "/login"),
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
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
