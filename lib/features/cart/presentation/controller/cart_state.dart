import '../../domain/entities/cart_item.dart';

class CartState {
  CartState({List<CartItem> items = const []}) : items = List.unmodifiable(items);

  final List<CartItem> items;

  int get totalQuantity => items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
