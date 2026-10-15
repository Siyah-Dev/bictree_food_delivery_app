import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/food/domain/utils/food_category_filter.dart';
import 'package:food_delivery_app/features/home/presentation/controller/home_state.dart';

import '../../../food/domain/entities/food.dart';
import '../../../food/presentation/providers/food_providers.dart';

class HomeController extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final repository = ref.watch(foodRepositoryProvider);
    final foods = await repository.getFoods(limit: 10, skip: 0);
    return HomeState(foods: foods);
  }

  
Future<void> refreshFoods() async {
  final previous = state;

  state = const AsyncLoading<HomeState>().copyWithPrevious(
    previous,
  );

  try {
    final foods = await ref
        .read(foodRepositoryProvider)
        .getFoods(limit: 10, skip: 0);

    final current = state.value ?? const HomeState();

    state = AsyncData(current.copyWith(foods: foods));
  } catch (error, stackTrace) {
    state = AsyncError<HomeState>(
      error,
      stackTrace,
    ).copyWithPrevious(previous);
  }
}


  void toggleCategory(String category) {
    final current = state.hasValue ? state.requireValue : const HomeState();
    state = AsyncData(
      current.selectedCategory == category
          ? current.copyWith(clearSelectedCategory: true)
          : current.copyWith(selectedCategory: category),
    );
  }

  List<Food> filterFoods() {
  final current = state.requireValue;

  return FoodCategoryFilter.filter(
    current.foods,
    category: current.selectedCategory,
  );
}

  List<Food> bestSellers(List<Food> foods) {
    final sorted = [...foods]..sort((a, b) => b.rating.compareTo(a.rating));

    return sorted.take(4).toList();
  }

  List<Food> recommended(List<Food> foods) => foods.take(10).toList();
}
