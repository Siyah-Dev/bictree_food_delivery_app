
import '../entities/food.dart';

abstract final class FoodCategoryFilter {
  static List<Food> filter(
    List<Food> foods, {
    String? category,
  }) {
    if (category == null) return foods;

    final normalizedCategory = category.toLowerCase();

    return foods.where((food) {
      final tags = food.tags.map((tag) => tag.toLowerCase());
      final mealTypes = food.mealType.map((meal) => meal.toLowerCase());

      switch (normalizedCategory) {
        case 'snacks':
          return tags.any(
            (tag) =>
                tag.contains('snack') ||
                tag.contains('appetizer') ||
                tag.contains('starter'),
          );

        case 'meal':
          return mealTypes.any(
            (meal) => [
              'breakfast',
              'lunch',
              'dinner',
            ].contains(meal),
          );

        case 'vegan':
          return tags.any(
            (tag) =>
                tag.contains('vegan') ||
                tag.contains('plant-based'),
          );

        case 'dessert':
          return mealTypes.any(
                (meal) => meal.contains('dessert'),
              ) ||
              tags.any(
                (tag) =>
                    tag.contains('dessert') ||
                    tag.contains('sweet'),
              );

        case 'drinks':
          return mealTypes.any(
                (meal) =>
                    meal.contains('drink') ||
                    meal.contains('beverage'),
              ) ||
              tags.any(
                (tag) =>
                    tag.contains('drink') ||
                    tag.contains('beverage'),
              );

        default:
          return true;
      }
    }).toList();
  }
}
