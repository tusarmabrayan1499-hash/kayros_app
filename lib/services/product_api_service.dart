import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/producto.dart';

class ProductApiService {
  static const _baseUrl = 'https://dummyjson.com/products';

  Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final products = (data['products'] as List<dynamic>).take(10).toList();
        return products.map((raw) {
          final item = raw as Map<String, dynamic>;
          return Producto(
            id: item['id'] as int,
            nombre: item['title'] as String,
            precio: (item['price'] as num).toDouble() * 4000,
            descripcion: item['description'] as String,
            imagen: _assetByName(item['title'] as String),
            categoria: _normalizeCategory(item['category'] as String),
          );
        }).toList();
      }
    } catch (_) {
      // fallback local
    }

    return _fallbackProductos;
  }

  String _normalizeCategory(String category) {
    final c = category.toLowerCase();
    if (c.contains('watch')) return 'Reloj';
    if (c.contains('audio') || c.contains('head')) return 'Audífonos';
    if (c.contains('sunglass') || c.contains('glass')) return 'Gafas';
    if (c.contains('mobile') || c.contains('phone')) return 'Smartphone';
    return 'Accesorios';
  }

  String _assetByName(String name) {
    final value = name.toLowerCase();
    if (value.contains('watch')) return 'assets/images/watch.jpg';
    if (value.contains('airpod') || value.contains('ear')) return 'assets/images/airpods.jpg';
    return 'assets/images/powerbank.jpg';
  }

  List<Producto> get _fallbackProductos => const [
        Producto(
          id: 1,
          nombre: 'AirPods Pro',
          precio: 299000,
          descripcion: 'Audífonos inalámbricos con cancelación activa de ruido.',
          imagen: 'assets/images/airpods.jpg',
          categoria: 'Audífonos',
        ),
        Producto(
          id: 2,
          nombre: 'Apple Watch',
          precio: 499000,
          descripcion: 'Reloj inteligente con monitoreo de salud y deporte.',
          imagen: 'assets/images/watch.jpg',
          categoria: 'Reloj',
        ),
        Producto(
          id: 3,
          nombre: 'Power Bank FastCharge',
          precio: 129000,
          descripcion: 'Batería portátil de alta capacidad y carga rápida.',
          imagen: 'assets/images/powerbank.jpg',
          categoria: 'Accesorios',
        ),
      ];
}
