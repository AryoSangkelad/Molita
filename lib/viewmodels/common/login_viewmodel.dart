import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:molita_flutter/core/services/AuthService.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailorUsernameController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? errorMessage;
  String? role;
  bool isLoading = false;

  Future<void> login(String emailOrUsername, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(emailOrUsername, password);

      if (result['success']) {
        // Simpan role dan data ke SharedPreferences
        role = result['role'];

        final data = result['data'];
        final prefs = await SharedPreferences.getInstance();
        print(data);
        await prefs.setString('role', role!);

        // Simpan data berdasarkan role
        if (role == 'admin') {
          await prefs.setString('id_admin', data['id_admin']);
          await prefs.setInt(
            'id_desa',
            int.tryParse(data['id_desa'].toString()) ?? 0,
          );
        } else if (role == 'orang_tua') {
          await prefs.setString('id_orang_tua', data['id_orang_tua']);
          await prefs.setString('id_jenis_posyandu', data['id_jenis_posyandu']);
          await prefs.setInt(
            'id_desa',
            int.tryParse(data['id_desa'].toString()) ?? 0,
          );
        }
      } else {
        errorMessage = result['message'];
      }
    } catch (e) {
      errorMessage = 'Terjadi kesalahan. Silakan coba lagi. ${e}';
      print(errorMessage);
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailorUsernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
