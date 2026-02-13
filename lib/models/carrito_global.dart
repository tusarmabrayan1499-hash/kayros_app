import 'producto.dart';

class CarritoGlobal {
  static List<Producto> items = [];

  static void agregar(Producto producto) {
    items.add(producto);
  }

  static void limpiar() {
    items.clear();
  }

  static double total() {
    return items.fold(0, (sum, item) => sum + item.precio);
  }
}
