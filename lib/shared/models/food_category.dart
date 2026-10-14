
class FoodCategory {
  const FoodCategory({
    required this.name,
    required this.asset,
  });

  final String name;
  final String asset;
}

abstract final class FoodCategories {
  static const List<FoodCategory> all = [
    FoodCategory(
      name: 'Snacks',
      asset: 'assets/icons/categories/snacks.svg',
    ),
    FoodCategory(
      name: 'Meal',
      asset: 'assets/icons/categories/meals.svg',
    ),
    FoodCategory(
      name: 'Vegan',
      asset: 'assets/icons/categories/vegan.svg',
    ),
    FoodCategory(
      name: 'Dessert',
      asset: 'assets/icons/categories/desserts.svg',
    ),
    FoodCategory(
      name: 'Drinks',
      asset: 'assets/icons/categories/drinks.svg',
    ),
  ];
}
