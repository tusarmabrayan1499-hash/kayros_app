import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  int? _currentUserId;

  int? get currentUserId => _currentUserId;

  Future<void> registrar(String email, String password) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existing.isNotEmpty) {
      throw Exception('email-already-in-use');
    }

    final id = await db.insert('users', {
      'email': email,
      'password': password,
    });

    _currentUserId = id;
  }

  Future<void> iniciarSesion(String email, String password) async {
    final db = await DatabaseService.instance.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isEmpty) {
      throw Exception('invalid-credential');
    }

    _currentUserId = result.first['id'] as int;
  }

  Future<void> recuperarPassword(String email) async {
    final db = await DatabaseService.instance.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) {
      throw Exception('user-not-found');
    }

    // Simulación académica
    return;
  }

  void cerrarSesion() {
    _currentUserId = null;
  }
}
