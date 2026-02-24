import 'package:flutter/material.dart';

import '../models/carrito_global.dart';
import '../models/producto.dart';

class DetalleProducto extends StatelessWidget {
  final Producto producto;

  const DetalleProducto({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(producto.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(producto.imagen, height: 220, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(producto.nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Categoría: ${producto.categoria}'),
            const SizedBox(height: 8),
            Text(producto.descripcion),
            const Spacer(),
            Text('\$${producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  CarritoGlobal.agregar(producto);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto agregado al carrito')));
                },
                child: const Text('Agregar al carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
