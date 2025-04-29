import 'package:flutter/material.dart';
import 'package:molita_flutter/core/routes/app_router.dart';
import 'package:molita_flutter/viewmodels/common/onboarding_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/dashboard_viewmodel.dart';
import 'package:molita_flutter/viewmodels/common/login_viewmodel.dart';
import 'package:molita_flutter/viewmodels/orang_tua/menu_viewmodel.dart';
import 'package:molita_flutter/viewmodels/common/register_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MolitaApp());
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
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
      ],
      child: MaterialApp(
        title: 'Molita',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: AppRoutes.routes,
      ),
    );
  }
}
