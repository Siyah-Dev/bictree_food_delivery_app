import '../../../food/domain/entities/food.dart';

class HomeState {
  const HomeState({
    this.foods = const [],
    this.selectedCategory,
  });

  final List<Food> foods;
  final String? selectedCategory;

  HomeState copyWith({
    List<Food>? foods,
    String? selectedCategory,
    bool clearSelectedCategory = false,
  }) {
    return HomeState(
      foods: foods ?? this.foods,
      selectedCategory: clearSelectedCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
    );
  }
}
