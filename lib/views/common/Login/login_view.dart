import 'package:flutter/material.dart';
import 'package:molita_flutter/core/constants/colors_constant.dart';
import 'package:molita_flutter/viewmodels/common/login_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: MediaQuery.of(context).size.width * .35,
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontFamily: 'PassionOne',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: ColorsConstant.brightBlue,
                  ),
                ),
                const SizedBox(height: 24),

                // Email
                TextField(
                  controller: loginViewModel.emailorUsernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Masukan Email / Username Anda',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: loginViewModel.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Masukan Sandi Anda',
                    prefixIcon: Icon(Icons.lock, color: Colors.blue),
                    suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Lupa Sandi?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        loginViewModel.isLoading
                            ? null
                            : () async {
                              await loginViewModel.login(
                                loginViewModel.emailorUsernameController.text,
                                loginViewModel.passwordController.text,
                              );
                              if (loginViewModel.orangTua != null) {
                                Navigator.pushNamed(
                                  context,
                                  '/home',
                                  arguments: loginViewModel.orangTua,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum daftar akun? ",
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                      ),
                      child: const Text(
                        "Daftar",
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
  }
}
