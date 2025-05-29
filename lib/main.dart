import 'package:flutter/material.dart';
import 'package:molita_flutter/core/routes/app_router.dart';
import 'package:molita_flutter/viewmodels/common/onboarding_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/chatbot_viewmodel.dart';
import 'package:molita_flutter/viewmodels/common/login_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/detail_anak_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/edukasi_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/kategori_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/lupa_password_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/menu_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/password_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pengaduan_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/penjadwalan_viewmodal.dart';
import 'package:molita_flutter/viewmodels/orang_tua/pertumbuhan_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/profile_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/register_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/theme_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await _requestLocationPermission(); // ← Meminta izin lokasi saat startup

  runApp(const MolitaApp());
}

Future<void> _requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    await Permission.location.request();
  }
}

class MolitaApp extends StatelessWidget {
  const MolitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => PertumbuhanViewModel()),
        ChangeNotifierProvider(create: (_) => PenjadwalanViewModal()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => ChatBotViewModel()),
        ChangeNotifierProvider(create: (_) => EdukasiViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => DetailAnakViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => PengaduanViewModel()),
        ChangeNotifierProvider(create: (_) => KategoriViewModel()),
        ChangeNotifierProvider(create: (_) => PasswordViewModel()),
        ChangeNotifierProvider(create: (_) => LupaPasswordViewModel()),
      ],
      child: MaterialApp(
        title: 'Molita',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: AppRoutes.routes,
        locale: const Locale('id', 'ID'),
        supportedLocales: const [Locale('id', 'ID')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
