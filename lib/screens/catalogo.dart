import 'package:flutter/material.dart';

import '../models/carrito_global.dart';
import '../models/producto.dart';
import '../services/product_api_service.dart';
import 'carrito.dart';
import 'contacto_soporte.dart';
import 'detalle_producto.dart';
import 'seguimiento.dart';

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

  @override
  State<Catalogo> createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  final _searchCtrl = TextEditingController();
  final _api = ProductApiService();

  List<Producto> _productos = [];
  String _categoriaSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final data = await _api.obtenerProductos();
    if (!mounted) return;
    setState(() => _productos = data);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = {'Todas', ..._productos.map((e) => e.categoria)}.toList();
    final query = _searchCtrl.text.toLowerCase();
    final visibles = _productos.where((p) {
      final byCategory = _categoriaSeleccionada == 'Todas' || p.categoria == _categoriaSeleccionada;
      final bySearch = p.nombre.toLowerCase().contains(query) || p.descripcion.toLowerCase().contains(query);
      return byCategory && bySearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Carrito())),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Kayros App')),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Seguimiento'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SeguimientoScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Contacto y soporte'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactoSoporteScreen())),
            ),
          ],
        ),
      ),
      body: _productos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar por nombre o palabra clave',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categorias.map((c) {
                      final selected = c == _categoriaSeleccionada;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: selected,
                          onSelected: (_) => setState(() => _categoriaSeleccionada = c),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: visibles.length,
                    itemBuilder: (context, index) {
                      final producto = visibles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Image.asset(producto.imagen, width: 56, fit: BoxFit.cover),
                          title: Text(producto.nombre),
                          subtitle: Text('${producto.categoria} · \$${producto.precio.toStringAsFixed(0)}'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetalleProducto(producto: producto)),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              CarritoGlobal.agregar(producto);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto agregado al carrito')));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
