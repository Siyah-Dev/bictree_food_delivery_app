import '../../domain/entities/food.dart';

class FoodModel extends Food {
  const FoodModel({
    required super.id,
    required super.name,
    required super.image,
    required super.rating,
    required super.reviewCount,
    required super.prepTimeMinutes,
    required super.cookTimeMinutes,
    required super.ingredients,
    required super.tags,
    required super.mealType,
    required super.price,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;

    return FoodModel(
      id: id,
      name: json['name'] as String? ?? 'Unnamed food',
      image: json['image'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      ingredients: _stringList(json['ingredients']),
      tags: _stringList(json['tags']),
      mealType: _stringList(json['mealType']),
      price: (json['price'] as num?)?.toDouble() ?? _mockPriceFor(id),
    );
  }

  factory FoodModel.fromEntity(Food food) {
    return FoodModel(
      id: food.id,
      name: food.name,
      image: food.image,
      rating: food.rating,
      reviewCount: food.reviewCount,
      prepTimeMinutes: food.prepTimeMinutes,
      cookTimeMinutes: food.cookTimeMinutes,
      ingredients: food.ingredients,
      tags: food.tags,
      mealType: food.mealType,
      price: food.price,
    );
  }

  factory FoodModel.fromCache(Map<dynamic, dynamic> json) {
    return FoodModel.fromJson(Map<String, dynamic>.from(json));
  }

  Food toEntity() {
    return Food(
      id: id,
      name: name,
      image: image,
      rating: rating,
      reviewCount: reviewCount,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      ingredients: ingredients,
      tags: tags,
      mealType: mealType,
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'ingredients': ingredients,
      'tags': tags,
      'mealType': mealType,
      'price': price,
    };
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];

    return value.whereType<String>().toList();
  }

  static double _mockPriceFor(int id) {
    return 149.0 + ((id * 37) % 351);
  }
}
