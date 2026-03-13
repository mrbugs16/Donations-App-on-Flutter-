// file: lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/app.dart';
import 'di/providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DonativosRoot());
}

class DonativosRoot extends StatelessWidget {
  const DonativosRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: const DonativosApp(),
    );
  }
}