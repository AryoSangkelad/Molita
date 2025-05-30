import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/lupa_password_viewmodel.dart';
import 'package:molita_flutter/views/common/lupa_password/verifikasi_otp_widgets/login_redirect.dart';
import 'package:molita_flutter/views/common/lupa_password/verifikasi_otp_widgets/otp_inputs.dart';
import 'package:molita_flutter/views/common/lupa_password/verifikasi_otp_widgets/verify_button.dart';
import 'package:provider/provider.dart';

class VerifikasiOtpView extends StatelessWidget {
  final String username;
  final String email;

  VerifikasiOtpView({Key? key, required this.username, required this.email})
    : super(key: key);

  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

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
                buildOtpInputs(context, _otpControllers),
                const SizedBox(height: 46),
                buildVerifyButton(
                  context,
                  viewModel,
                  _otpControllers,
                  username,
                ),
                const SizedBox(height: 14),
                buildLoginRedirect(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
