import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/features/food/domain/entities/food.dart';
import 'package:food_delivery_app/features/food/presentation/providers/food_providers.dart';
import 'package:food_delivery_app/features/menu/presentation/controller/menu_state.dart';
import 'package:food_delivery_app/features/menu/presentation/providers/menu_providers.dart';

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

    final initialLoad = container.read(menuControllerProvider.future);
    expect(container.read(menuControllerProvider).isLoading, isTrue);
    await expectLater(initialLoad, throwsA(isA<StateError>()));
    expect(container.read(menuControllerProvider).hasError, isTrue);

    await container.read(menuControllerProvider.notifier).refreshFoods();
    expect(container.read(menuControllerProvider).hasValue, isTrue);
    expect(container.read(menuControllerProvider).requireValue.foods, isEmpty);
  });

  test('loads foods and category and sort update results', () async {
    final later = _food(id: 1, name: 'Ziti', reviewCount: 2);
    final earlier = _food(id: 2, name: 'Apple pie', reviewCount: 8);
    final meal = _food(
      id: 3,
      name: 'Bowl',
      reviewCount: 20,
      tags: const [],
      mealType: const ['Lunch'],
    );
    final otherMeal = _food(id: 4, name: 'A bowl', tags: const [], mealType: const ['Lunch']);
    final container = ProviderContainer(
      overrides: [
        foodRepositoryProvider.overrideWithValue(
          FakeFoodRepository(() async => [later, earlier, meal, otherMeal]),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(menuControllerProvider.future);
    final controller = container.read(menuControllerProvider.notifier);

    final initialState = container.read(menuControllerProvider).requireValue;

    expect(controller.filterAndSortFoods(initialState), [earlier, later]);

    controller.selectCategory('Meal');
    controller.selectSort(MenuSort.name);

    final updatedState = container.read(menuControllerProvider).requireValue;

    expect(controller.filterAndSortFoods(updatedState), [otherMeal, meal]);

    expect(container.read(menuControllerProvider).requireValue.selectedCategory, 'Meal');
    expect(container.read(menuControllerProvider).requireValue.sort, MenuSort.name);
  });

  test('favorite toggles update the state set', () async {
    final container = ProviderContainer(
      overrides: [foodRepositoryProvider.overrideWithValue(FakeFoodRepository(() async => []))],
    );
    addTearDown(container.dispose);

    await container.read(menuControllerProvider.future);
    final controller = container.read(menuControllerProvider.notifier);
    controller.toggleFavorite(42);
    final favoriteIds = container.read(menuControllerProvider).requireValue.favoriteIds;
    expect(favoriteIds, contains(42));
    expect(() => favoriteIds.add(10), throwsUnsupportedError);

    controller.toggleFavorite(42);
    expect(container.read(menuControllerProvider).requireValue.favoriteIds, isEmpty);
  });
}

Food _food({
  required int id,
  required String name,
  int reviewCount = 0,
  List<String> tags = const ['snack'],
  List<String> mealType = const [],
}) {
  return Food(
    id: id,
    name: name,
    image: '',
    rating: 4,
    reviewCount: reviewCount,
    prepTimeMinutes: 5,
    cookTimeMinutes: 10,
    ingredients: const [],
    tags: tags,
    mealType: mealType,
    price: 1,
  );
}
