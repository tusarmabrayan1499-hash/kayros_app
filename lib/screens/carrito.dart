import 'package:flutter/material.dart';
import '../models/carrito_global.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  @override
  Widget build(BuildContext context) {
    final items = CarritoGlobal.items;
    final total = CarritoGlobal.total();

    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
        backgroundColor: const Color(0xFF37474F),
        title: const Text(
          'CARRITO',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'El carrito está vacío',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        color: const Color(0xFF37474F),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            item.nombre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '\$${item.precio.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // TOTAL
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'TOTAL: \$${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // BOTÓN CONFIRMAR
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00CFCB),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        CarritoGlobal.limpiar();
                        setState(() {});
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Compra Exitosa'),
                            content: const Text(
                                'Gracias por tu compra.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              )
                            ],
                          ),
                        );
                      },
                      child: const Text('CONFIRMAR PEDIDO'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

