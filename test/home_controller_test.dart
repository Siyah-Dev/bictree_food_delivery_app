import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/features/food/domain/entities/food.dart';
import 'package:food_delivery_app/features/food/presentation/providers/food_providers.dart';
import 'package:food_delivery_app/features/home/presentation/providers/home_providers.dart';

import 'helpers/fake_food_repository.dart';

void main() {
  test('exposes loading and error states and can retry', () async {
    var attempt = 0;
    final container = ProviderContainer(
      overrides: [
        foodRepositoryProvider.overrideWithValue(
          FakeFoodRepository(() async {
            attempt++;
            if (attempt == 1) throw StateError('temporary failure');
            return [];
          }),
        ),
      ],
    );
    addTearDown(container.dispose);

    final initialLoad = container.read(homeControllerProvider.future);
    expect(container.read(homeControllerProvider).isLoading, isTrue);
    await expectLater(initialLoad, throwsA(isA<StateError>()));
    expect(container.read(homeControllerProvider).hasError, isTrue);

    await container.read(homeControllerProvider.notifier).refreshFoods();
    expect(container.read(homeControllerProvider).hasValue, isTrue);
    expect(container.read(homeControllerProvider).requireValue.foods, isEmpty);
  });

  test('loads foods and category selection toggles filtering', () async {
    final snacks = _food(id: 1, tags: const ['snack']);
    final veganMeal = _food(
      id: 2,
      tags: const ['vegan'],
      mealType: const ['lunch'],
    );
    final container = ProviderContainer(
      overrides: [
        foodRepositoryProvider.overrideWithValue(
          FakeFoodRepository(() async => [snacks, veganMeal]),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(homeControllerProvider.future);
    final controller = container.read(homeControllerProvider.notifier);

    expect(container.read(homeControllerProvider).hasValue, isTrue);
    expect(container.read(homeControllerProvider).value!.foods, [
      snacks,
      veganMeal,
    ]);
    controller.toggleCategory('Snacks');

    expect(
      container.read(homeControllerProvider).requireValue.selectedCategory,
      'Snacks',
    );

    final initialState = container.read(homeControllerProvider).requireValue;
    expect(controller.filterFoods(initialState), [snacks]);

    controller.toggleCategory('Snacks');
    expect(
      container.read(homeControllerProvider).requireValue.selectedCategory,
      isNull,
    );

    final updatedState = container.read(homeControllerProvider).requireValue;
    expect(controller.filterFoods(updatedState), [snacks, veganMeal]);
  });
}

Food _food({
  required int id,
  List<String> tags = const [],
  List<String> mealType = const [],
}) {
  return Food(
    id: id,
    name: 'Food $id',
    image: '',
    rating: 4,
    reviewCount: 0,
    prepTimeMinutes: 5,
    cookTimeMinutes: 10,
    ingredients: const [],
    tags: tags,
    mealType: mealType,
    price: 1,
  );
}
