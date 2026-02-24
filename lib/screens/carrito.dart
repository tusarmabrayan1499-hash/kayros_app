import 'package:flutter/material.dart';

import '../models/carrito_global.dart';
import '../services/order_service.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  String _metodoPago = 'Contra entrega';

  Future<void> _confirmarPedido() async {
    if (CarritoGlobal.items.isEmpty) return;

    final orderId = await OrderService.instance.crearOrden(
      items: CarritoGlobal.items,
      paymentMethod: _metodoPago,
    );

    CarritoGlobal.limpiar();
    if (!mounted) return;
    setState(() {});

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pedido confirmado'),
        content: Text('Tu pedido #$orderId fue registrado exitosamente.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = CarritoGlobal.items;
    final total = CarritoGlobal.total();

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: items.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item.producto.nombre),
                        subtitle: Text('Subtotal: \$${item.subtotal.toStringAsFixed(0)}'),
                        leading: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            CarritoGlobal.eliminar(item.producto.id);
                            setState(() {});
                          },
                        ),
                        trailing: SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  CarritoGlobal.actualizarCantidad(item.producto.id, item.cantidad - 1);
                                  setState(() {});
                                },
                              ),
                              Text('${item.cantidad}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  CarritoGlobal.actualizarCantidad(item.producto.id, item.cantidad + 1);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Método de pago'),
                  trailing: DropdownButton<String>(
                    value: _metodoPago,
                    items: const [
                      DropdownMenuItem(value: 'Contra entrega', child: Text('Contra entrega')),
                      DropdownMenuItem(value: 'Digital', child: Text('Digital')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _metodoPago = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Total: \$${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: _confirmarPedido, child: const Text('Confirmar pedido')),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
