
import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../food/domain/entities/food.dart';
import '../../data/providers/cart_data_providers.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_state.dart';

class CartController extends Notifier<CartState> {
  Future<void> _writeQueue = Future<void>.value();

  @override
  CartState build() {
    final dataSource = ref.watch(cartLocalDataSourceProvider);

    return CartState(
      items: dataSource.loadItems(),
    );
  }

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

    _updateItems(items);
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

    _updateItems(items);
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

    _updateItems(items);
  }

  void removeItem(String configurationKey) {
    final items = state.items
        .where((item) => item.configurationKey != configurationKey)
        .toList();

    _updateItems(items);
  }

  void clear() {
    _updateItems(const []);
  }

  void _updateItems(List<CartItem> items) {
    final snapshot = List<CartItem>.unmodifiable(items);

    // Update the UI immediately.
    state = state.copyWith(items: snapshot);

    // Persist a snapshot of this exact state. Serialize writes in order.
    _writeQueue = _writeQueue
        .then(
          (_) => ref
              .read(cartLocalDataSourceProvider)
              .saveItems(snapshot),
        )
        .catchError((Object error, StackTrace stackTrace) {
          developer.log(
            'Failed to persist cart to Hive.',
            name: 'CartController',
            error: error,
            stackTrace: stackTrace,
          );
        });
  }
}
