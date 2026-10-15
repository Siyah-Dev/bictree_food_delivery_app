import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/food/domain/utils/food_category_filter.dart';
import 'package:food_delivery_app/features/menu/presentation/controller/menu_state.dart';

import '../../../food/domain/entities/food.dart';
import '../../../food/presentation/providers/food_providers.dart';

class MenuController extends AsyncNotifier<MenuState> {
  @override
  Future<MenuState> build() async {
    final repository = ref.watch(foodRepositoryProvider);
    final foods = await repository.getFoods(limit: 50, skip: 0);
    return MenuState(foods: foods);
  }

  Future<void> refreshFoods() async {
    final previousState = state;

    try {
      final foods = await ref.read(foodRepositoryProvider).getFoods(limit: 50, skip: 0);

      final current = previousState.value ?? const MenuState();

      state = AsyncData(current.copyWith(foods: foods));
    } catch (error, stackTrace) {
      if (!previousState.hasValue) {
        state = AsyncError(error, stackTrace);
        return;
      }
      rethrow;
    }
  }

  void selectCategory(String category) {
    final current = state.hasValue ? state.requireValue : const MenuState();
    state = AsyncData(current.copyWith(selectedCategory: category));
  }

  void selectSort(MenuSort sort) {
    final current = state.hasValue ? state.requireValue : const MenuState();
    state = AsyncData(current.copyWith(sort: sort));
  }

  void toggleFavorite(int foodId) {
    final current = state.hasValue ? state.requireValue : const MenuState();
    final favoriteIds = Set<int>.of(current.favoriteIds);
    if (!favoriteIds.add(foodId)) {
      favoriteIds.remove(foodId);
    }
    state = AsyncData(current.copyWith(favoriteIds: Set<int>.unmodifiable(favoriteIds)));
  }

  List<Food> filterAndSortFoods(MenuState current) {

    final filtered = [
      ...FoodCategoryFilter.filter(current.foods, category: current.selectedCategory),
    ];

    switch (current.sort) {
      case MenuSort.popular:
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case MenuSort.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
      case MenuSort.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
      case MenuSort.cookingTime:
        filtered.sort((a, b) => a.totalTimeMinutes.compareTo(b.totalTimeMinutes));
    }

    return filtered;
  }
}
