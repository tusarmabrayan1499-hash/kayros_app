import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/carrito_global.dart';
import 'carrito.dart';

class Catalogo extends StatelessWidget {
  const Catalogo({super.key});

  @override
  Widget build(BuildContext context) {
    final productos = [
      Producto(
        nombre: 'AirPods',
        precio: 299000,
        descripcion: 'Audífonos inalámbricos con cancelación de ruido.',
        imagen: 'assets/images/airpods.jpg',
      ),
      Producto(
        nombre: 'Apple Watch',
        precio: 499000,
        descripcion: 'Reloj inteligente con monitoreo deportivo.',
        imagen: 'assets/images/watch.jpg',
      ),
      Producto(
        nombre: 'Power Bank',
        precio: 129000,
        descripcion: 'Batería portátil de alta capacidad.',
        imagen: 'assets/images/powerbank.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF37474F),
        title: const Text('CATÁLOGO'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGEN
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      producto.imagen,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // INFORMACIÓN
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          '\$${producto.precio.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00CFCB),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            CarritoGlobal.agregar(producto);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Producto agregado al carrito'),
                              ),
                            );
                          },
                          child: const Text('AÑADIR AL CARRITO'),
                        ),

                        const SizedBox(height: 6),

                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: const Text(
                            'ESPECIFICACIONES',
                            style: TextStyle(fontSize: 14),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(producto.descripcion),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // BOTÓN FIJO
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: const Color(0xFF263238),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00CFCB),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(15),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Carrito()),
            );
          },
          child: const Text('VER CARRITO'),
        ),
      ),
    );
  }
}


