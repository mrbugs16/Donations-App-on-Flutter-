// file: lib/core/app.dart
import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class DonativosApp extends StatelessWidget {
  const DonativosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donativos ante desastres',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}