import 'package:flutter/material.dart';

import '../services/order_service.dart';

class SeguimientoScreen extends StatefulWidget {
  const SeguimientoScreen({super.key});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = OrderService.instance.listarOrdenes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento de pedidos')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final orders = snapshot.data!;
          if (orders.isEmpty) return const Center(child: Text('No hay pedidos aún'));

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text('Pedido #${order['id']} - ${order['status']}'),
                  subtitle: Text('Total: \$${(order['total'] as num).toStringAsFixed(0)}\nPago: ${order['payment_method']}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      await OrderService.instance.actualizarEstado(order['id'] as int, value);
                      setState(() {
                        _future = OrderService.instance.listarOrdenes();
                      });
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'en preparación', child: Text('En preparación')),
                      PopupMenuItem(value: 'en camino', child: Text('En camino')),
                      PopupMenuItem(value: 'entregado', child: Text('Entregado')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
