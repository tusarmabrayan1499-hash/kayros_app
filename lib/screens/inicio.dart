import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../services/auth_service.dart';
import 'catalogo.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _recoverCtrl = TextEditingController();

  int _tabIndex = 0;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _recoverCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    try {
      await AuthService.instance.registrar(_emailCtrl.text, _passwordCtrl.text);
      if (!mounted) return;
      _snack('Registro exitoso');
      _irCatalogo();
    } on DatabaseException {
      _snack('Ese correo ya está registrado');
    }
  }

  Future<void> _login() async {
    final ok = await AuthService.instance.iniciarSesion(_emailCtrl.text, _passwordCtrl.text);
    if (!mounted) return;
    if (ok) {
      _irCatalogo();
    } else {
      _snack('Credenciales inválidas');
    }
  }

  Future<void> _recuperarPassword() async {
    final email = _recoverCtrl.text;
    final existe = await AuthService.instance.existeUsuario(email);
    if (!mounted) return;

    if (!existe) {
      _snack('No se encontró el correo en el sistema');
      return;
    }

    await AuthService.instance.actualizarPassword(email, '123456');
    if (!mounted) return;
    _snack('Se envió correo de recuperación. Nueva clave temporal: 123456');
  }

  void _irCatalogo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Catalogo()),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset('assets/images/logo.png', width: 130),
              const SizedBox(height: 12),
              const Text('KAYROS B&T', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ToggleButtons(
                isSelected: [0, 1, 2].map((i) => i == _tabIndex).toList(),
                onPressed: (index) => setState(() => _tabIndex = index),
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.black,
                fillColor: const Color(0xFF00CFCB),
                color: Colors.white,
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Iniciar sesión')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Registrarse')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Recuperar')),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_tabIndex == 2) {
      return Column(
        children: [
          TextField(
            controller: _recoverCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Correo', labelStyle: TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _recuperarPassword, child: const Text('Recuperar contraseña')),
        ],
      );
    }

    final isLogin = _tabIndex == 0;
    return Column(
      children: [
        TextField(
          controller: _emailCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Correo electrónico', labelStyle: TextStyle(color: Colors.white70)),
        ),
        TextField(
          controller: _passwordCtrl,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Contraseña', labelStyle: TextStyle(color: Colors.white70)),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00CFCB), foregroundColor: Colors.black),
          onPressed: isLogin ? _login : _registrar,
          child: Text(isLogin ? 'Iniciar sesión' : 'Crear cuenta'),
        ),
      ],
    );
  }
}
