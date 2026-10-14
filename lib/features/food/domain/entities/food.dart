class Food {
  const Food({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.ingredients,
    required this.tags,
    required this.mealType,
    required this.price,
  });

  final int id;
  final String name;
  final String image;
  final double rating;
  final int reviewCount;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final List<String> ingredients;
  final List<String> tags;
  final List<String> mealType;
  final double price;

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;
}
