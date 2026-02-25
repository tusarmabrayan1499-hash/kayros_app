import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/inicio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const KayrosApp());
}

class KayrosApp extends StatelessWidget {
  const KayrosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kayros App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00CFCB)),
        useMaterial3: true,
      ),
      home: const Inicio(),
    );
  }
}
