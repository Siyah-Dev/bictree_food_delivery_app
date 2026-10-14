
abstract final class SearchFilterOptions {
  static const Map<String, List<String>> chipsByCategory = {
    'Snacks': [
      'Bruschetta',
      'Spring Rolls',
      'Crepes',
      'Wings',
      'Skewers',
      'Salmon',
      'Mexican',
      'Baked',
      'Appetizer',
    ],
    'Meal': [
      'Sushi',
      'Pizza',
      'Chicken',
      'Curry',
      'Burger',
      'Cheese',
      'Fresh Prawn',
      'Ceviche',
      'Pad Thai',
    ],
    'Vegan': [
      'Bean Burger',
      'Mushroom',
      'Hummus',
      'Salad',
      'Tofu',
      'Lentils',
      'Quinoa',
      'Falafel',
      'Avocado',
    ],
    'Dessert': [
      'Cupcake',
      'Crepes',
      'Cookies',
      'Cake',
      'Chocolate',
      'Cheesecake',
      'Pudding',
      'Brownies',
      'Ice Cream',
    ],
    'Drinks': [
      'Smoothie',
      'Juice',
      'Coffee',
      'Tea',
      'Milkshake',
      'Lemonade',
      'Matcha',
      'Iced Tea',
      'Mocktail',
    ],
  };

  static const Map<String, List<String>> initialSelections = {
    'Snacks': ['Skewers', 'Salmon'],
    'Meal': ['Sushi', 'Curry'],
    'Vegan': ['Mushroom'],
    'Dessert': [],
    'Drinks': [],
  };

  static List<String> chipsFor(String category) {
    return chipsByCategory[category] ?? const [];
  }

  static List<String> initialSelectionFor(String category) {
    return initialSelections[category] ?? const [];
  }
}
