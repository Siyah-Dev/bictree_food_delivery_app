import '../../../food/domain/entities/food.dart';

enum MenuSort {
  popular('Popular'),
  rating('Rating'),
  name('Name'),
  cookingTime('Cooking Time');

  const MenuSort(this.label);

  final String label;
}

class MenuState {
  const MenuState({
    this.foods = const [],
    this.selectedCategory = 'Snacks',
    this.sort = MenuSort.popular,
    this.favoriteIds = const {},
  });

  final List<Food> foods;
  final String selectedCategory;
  final MenuSort sort;
  final Set<int> favoriteIds;

  MenuState copyWith({
    List<Food>? foods,
    String? selectedCategory,
    MenuSort? sort,
    Set<int>? favoriteIds,
  }) {
    return MenuState(
      foods: foods ?? this.foods,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}
