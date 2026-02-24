import 'package:sqflite/sqflite.dart';

import '../models/carrito_item.dart';
import 'database_service.dart';

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  Future<int> crearOrden({
    required List<CarritoItem> items,
    required String paymentMethod,
  }) async {
    final db = await DatabaseService.instance.database;
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);

    return db.insert('orders', {
      'total': total,
      'payment_method': paymentMethod,
      'status': 'en preparación',
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> listarOrdenes() async {
    final db = await DatabaseService.instance.database;
    return db.query('orders', orderBy: 'id DESC');
  }

  Future<void> actualizarEstado(int id, String status) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
