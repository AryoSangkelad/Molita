import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/lupa_password_viewmodel.dart';
import 'package:provider/provider.dart';

class GantiPasswordScreen extends StatefulWidget {
  final String username;

  const GantiPasswordScreen({Key? key, required this.username})
    : super(key: key);

  @override
  State<GantiPasswordScreen> createState() => _GantiPasswordScreenState();
}

class _GantiPasswordScreenState extends State<GantiPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isObscure1 = true;
  bool isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LupaPasswordViewModel>(context);
    const Color primaryColor = Color(0xFF00A0D1);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/l_ganti_sandi.png', // Ganti sesuai nama file
                  height: 280,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ubah sandi',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Masukkan kata sandi baru untuk\nmengubah sandi lama anda.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(208, 25, 118, 210),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Password Baru
                TextField(
                  controller: passwordController,
                  obscureText: isObscure1,
                  decoration: InputDecoration(
                    hintText: 'Sandi Baru...',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.blue[700],
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 2, 125, 162),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure1 ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue[700],
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure1 = !isObscure1;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 208, 232, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 2, 125, 162),
                  ),
                ),

                const SizedBox(height: 16),

                // Konfirmasi Password
                TextField(
                  controller: confirmController,
                  obscureText: isObscure2,
                  decoration: InputDecoration(
                    hintText: 'Konfirmasi Sandi...',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color:
                          Colors
                              .blue[700], // Ganti warna prefix icon sesuai selera
                    ),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 2, 125, 162),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure2 ? Icons.visibility : Icons.visibility_off,
                        color:
                            Colors
                                .blue[700], // Ganti warna suffix icon sesuai selera
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure2 = !isObscure2;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 208, 232, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 2, 125, 162),
                  ),
                ),

                const SizedBox(height: 28),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final password = passwordController.text.trim();
                      final confirm = confirmController.text.trim();

                      if (password.isEmpty || confirm.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harap isi semua kolom'),
                          ),
                        );
                        return;
                      }

                      if (password != confirm) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password tidak cocok')),
                        );
                        return;
                      }

                      final success = await viewModel.gantiPassword(
                        widget.username,
                        password,
                      );
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password berhasil diubah'),
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal mengganti password'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Ubah Sandi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
