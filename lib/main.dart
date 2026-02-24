import 'package:flutter/material.dart';

import 'screens/inicio.dart';

void main() {
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
