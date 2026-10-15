import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/features/cart/data/providers/cart_data_providers.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_item.dart';
import 'package:food_delivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:food_delivery_app/features/food/domain/entities/food.dart';

import 'helpers/fake_cart_local_data_source.dart';

void main() {
  group('CartController', () {
    late FakeCartLocalDataSource localDataSource;
    late ProviderContainer container;

    setUp(() {
      localDataSource = FakeCartLocalDataSource();
      container = ProviderContainer(
        overrides: [
          cartLocalDataSourceProvider.overrideWithValue(localDataSource),
        ],
      );
    });

    tearDown(() async {
      // Allow queued persistence writes to finish before disposing providers.
      await Future<void>.delayed(Duration.zero);
      container.dispose();
    });

    test('starts with an empty cart', () {
      final state = container.read(cartControllerProvider);

      expect(state.isEmpty, isTrue);
      expect(state.totalQuantity, 0);
      expect(state.subtotal, 0);
    });

    test('adds item and calculates subtotal including add-ons', () async {
      final controller = container.read(cartControllerProvider.notifier);

      controller.addItem(
        food: _food(id: 1, price: 10),
        quantity: 2,
        addOns: const [CartAddOn(id: 'cheese', name: 'Cheese', price: 2)],
      );

      final state = container.read(cartControllerProvider);
      expect(state.items, hasLength(1));
      expect(state.items.single.quantity, 2);
      expect(state.totalQuantity, 2);
      expect(state.subtotal, 24); // (10 + 2) * 2

      await Future<void>.delayed(Duration.zero);
      expect(localDataSource.savedItems.single.quantity, 2);
    });

    test('merges items with the same configuration', () {
      final controller = container.read(cartControllerProvider.notifier);
      final food = _food(id: 7, price: 5);
      const addOns = [CartAddOn(id: 'sauce', name: 'Sauce', price: 1)];

      controller.addItem(food: food, quantity: 1, addOns: addOns);
      controller.addItem(food: food, quantity: 2, addOns: addOns);

      final state = container.read(cartControllerProvider);
      expect(state.items, hasLength(1));
      expect(state.items.single.quantity, 3);
      expect(state.subtotal, 18); // (5 + 1) * 3
    });

    test('keeps different add-on configurations as separate items', () {
      final controller = container.read(cartControllerProvider.notifier);
      final food = _food(id: 9, price: 8);

      controller.addItem(food: food, quantity: 1, addOns: const []);
      controller.addItem(
        food: food,
        quantity: 1,
        addOns: const [CartAddOn(id: 'spicy', name: 'Spicy sauce', price: 1.5)],
      );

      final state = container.read(cartControllerProvider);
      expect(state.items, hasLength(2));
      expect(state.subtotal, 17.5);
    });

    test(
      'increment and decrement update quantity and remove at zero boundary',
      () {
        final controller = container.read(cartControllerProvider.notifier);
        final food = _food(id: 3, price: 4);

        controller.addItem(food: food, quantity: 1, addOns: const []);
        final key = container
            .read(cartControllerProvider)
            .items
            .single
            .configurationKey;

        controller.increment(key);
        expect(container.read(cartControllerProvider).items.single.quantity, 2);

        controller.decrement(key);
        expect(container.read(cartControllerProvider).items.single.quantity, 1);

        controller.decrement(key);
        expect(container.read(cartControllerProvider).isEmpty, isTrue);
      },
    );

    test('removeItem and clear empty the cart', () {
      final controller = container.read(cartControllerProvider.notifier);
      controller.addItem(
        food: _food(id: 4, price: 6),
        quantity: 1,
        addOns: const [],
      );

      final key = container
          .read(cartControllerProvider)
          .items
          .single
          .configurationKey;
      controller.removeItem(key);
      expect(container.read(cartControllerProvider).isEmpty, isTrue);

      controller.addItem(
        food: _food(id: 5, price: 3),
        quantity: 1,
        addOns: const [],
      );
      controller.clear();
      expect(container.read(cartControllerProvider).isEmpty, isTrue);
    });
  });
}

Food _food({required int id, required double price}) {
  return Food(
    id: id,
    name: 'Food $id',
    image: '',
    rating: 4.5,
    reviewCount: 10,
    prepTimeMinutes: 5,
    cookTimeMinutes: 10,
    ingredients: const ['ingredient'],
    tags: const ['snack'],
    mealType: const ['Lunch'],
    price: price,
  );
}
