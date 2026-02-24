import 'carrito_item.dart';
import 'producto.dart';

class CarritoGlobal {
  static final List<CarritoItem> _items = [];

  static List<CarritoItem> get items => List.unmodifiable(_items);

  static void agregar(Producto producto) {
    CarritoItem? existente;
    for (final item in _items) {
      if (item.producto.id == producto.id) {
        existente = item;
        break;
      }
    }

    if (existente != null) {
      existente.cantidad++;
      return;
    }

    _items.add(CarritoItem(producto: producto));
  }

  static void actualizarCantidad(int productId, int nuevaCantidad) {
    CarritoItem? item;
    for (final value in _items) {
      if (value.producto.id == productId) {
        item = value;
        break;
      }
    }

    if (item == null) return;

    if (nuevaCantidad <= 0) {
      _items.remove(item);
    } else {
      item.cantidad = nuevaCantidad;
    }
  }

  static void eliminar(int productId) {
    _items.removeWhere((item) => item.producto.id == productId);
  }

  static void limpiar() {
    _items.clear();
  }

  static double total() {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }
}
