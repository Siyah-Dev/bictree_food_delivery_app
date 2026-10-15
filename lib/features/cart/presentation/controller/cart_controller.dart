import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../food/domain/entities/food.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_state.dart';

class CartController extends Notifier<CartState> {
  @override
  CartState build() => CartState();

  void addItem({
    required Food food,
    required int quantity,
    required List<CartAddOn> addOns,
  }) {
    if (quantity < 1) return;

    final incoming = CartItem(
      food: food,
      quantity: quantity,
      addOns: addOns,
    );
    final items = [...state.items];
    final index = items.indexWhere(
      (item) => item.configurationKey == incoming.configurationKey,
    );

    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    } else {
      items.add(incoming);
    }

    state = state.copyWith(items: items);
  }

  void increment(String configurationKey) {
    final items = [...state.items];
    final index = items.indexWhere(
      (item) => item.configurationKey == configurationKey,
    );
    if (index < 0) return;

    items[index] = items[index].copyWith(
      quantity: items[index].quantity + 1,
    );
    state = state.copyWith(items: items);
  }

  void decrement(String configurationKey) {
    final items = [...state.items];
    final index = items.indexWhere(
      (item) => item.configurationKey == configurationKey,
    );
    if (index < 0) return;

    if (items[index].quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity - 1,
      );
    }

    state = state.copyWith(items: items);
  }

  void removeItem(String configurationKey) {
    state = state.copyWith(
      items: state.items
          .where((item) => item.configurationKey != configurationKey)
          .toList(),
    );
  }

  void clear() {
    state = CartState();
  }
}
