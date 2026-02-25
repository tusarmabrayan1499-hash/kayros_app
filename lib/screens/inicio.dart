import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _recoverCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_validarCredenciales()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.registrar(_emailCtrl.text, _passwordCtrl.text);
      if (!mounted) return;
      _snack('Registro exitoso. Ya puedes iniciar sesión.');
      setState(() => _tabIndex = 0);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _snack(_mensajeRegistro(e));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _login() async {
    if (!_validarCredenciales()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.iniciarSesion(_emailCtrl.text, _passwordCtrl.text);
      if (!mounted) return;
      _irCatalogo();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _snack(_mensajeLogin(e));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _recuperarPassword() async {
    final email = _recoverCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _snack('Ingresa un correo válido para recuperar tu contraseña');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.recuperarPassword(email);
      if (!mounted) return;
      _snack('Te enviamos un correo para restablecer tu contraseña.');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'user-not-found') {
        _snack('No existe una cuenta registrada con ese correo.');
      } else {
        _snack('No fue posible enviar el correo de recuperación.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validarCredenciales() {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || !email.contains('@')) {
      _snack('Ingresa un correo válido');
      return false;
    }

    if (password.length < 6) {
      _snack('La contraseña debe tener al menos 6 caracteres');
      return false;
    }

    return true;
  }

  String _mensajeRegistro(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Ese correo ya está registrado.';
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      default:
        return 'No fue posible registrar la cuenta.';
    }
  }

  String _mensajeLogin(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Correo o contraseña incorrectos.';
      default:
        return 'No fue posible iniciar sesión.';
    }
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
                onPressed: _isLoading ? null : (index) => setState(() => _tabIndex = index),
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
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo', labelStyle: TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _recuperarPassword,
            child: _isLoading
                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Recuperar contraseña'),
          ),
        ],
      );
    }

    final isLogin = _tabIndex == 0;
    return Column(
      children: [
        TextField(
          controller: _emailCtrl,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
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
          onPressed: _isLoading ? null : (isLogin ? _login : _registrar),
          child: _isLoading
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(isLogin ? 'Iniciar sesión' : 'Crear cuenta'),
        ),
      ],
    );
  }
}
