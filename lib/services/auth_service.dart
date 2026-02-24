import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Future<void> registrar(String email, String password) async {
    final db = await DatabaseService.instance.database;
    await db.insert('users', {'email': email.trim(), 'password': password});
  }

  Future<bool> iniciarSesion(String email, String password) async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim(), password],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> existeUsuario(String email) async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim()],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> actualizarPassword(String email, String nuevaPassword) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      'users',
      {'password': nuevaPassword},
      where: 'email = ?',
      whereArgs: [email.trim()],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
