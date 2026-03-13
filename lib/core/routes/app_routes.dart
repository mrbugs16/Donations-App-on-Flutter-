import 'package:flutter/material.dart';

import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/main_navigation.dart';
import '../../presentation/screens/donation_form_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String main = '/main';
  static const String donationForm = '/donation-form';

  static String get initialRoute => login;

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginScreen(),
    main: (_) => const MainNavigation(),
    donationForm: (_) => const DonationFormScreen(),
  };
}