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
        scaffoldBackgroundColor: const Color(0xFF263238),
        primaryColor: const Color(0xFF00CFCB),
      ),
      home: const Inicio(),
    );
  }
}
