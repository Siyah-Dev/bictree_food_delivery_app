
import 'package:hive_flutter/hive_flutter.dart';

import '../../../food/domain/entities/food.dart';
import '../../domain/entities/cart_item.dart';

class CartLocalDataSource {
  CartLocalDataSource(this._box);

  final Box<Map> _box;

  static const _storageKey = 'cart_state';

  List<CartItem> loadItems() {
    final saved = _box.get(_storageKey);
    final rawItems = saved?['items'];

    if (rawItems is! List) {
      return const [];
    }

    final items = <CartItem>[];

    for (final rawItem in rawItems) {
      if (rawItem is! Map) continue;

      try {
        items.add(_decodeCartItem(rawItem));
      } on Object {
        // Ignore invalid entries so they don't prevent the cart from loading.
        continue;
      }
    }

    return items;
  }

  Future<void> saveItems(List<CartItem> items) async {
    await _box.put(
      _storageKey,
      {
        'items': items.map(_encodeCartItem).toList(),
      },
    );
  }

  Map<String, dynamic> _encodeCartItem(CartItem item) {
    final food = item.food;

    return {
      'food': {
        'id': food.id,
        'name': food.name,
        'image': food.image,
        'rating': food.rating,
        'reviewCount': food.reviewCount,
        'prepTimeMinutes': food.prepTimeMinutes,
        'cookTimeMinutes': food.cookTimeMinutes,
        'ingredients': food.ingredients,
        'tags': food.tags,
        'mealType': food.mealType,
        'price': food.price,
      },
      'quantity': item.quantity,
      'addOns': item.addOns.map((addOn) {
        return {
          'id': addOn.id,
          'name': addOn.name,
          'price': addOn.price,
        };
      }).toList(),
    };
  }

  CartItem _decodeCartItem(Map raw) {
    final rawFood = raw['food'];

    if (rawFood is! Map) {
      throw const FormatException('Invalid cart item.');
    }

    final foodData = Map<String, dynamic>.from(rawFood);
    final addOns = <CartAddOn>[];
    final rawAddOns = raw['addOns'];

    if (rawAddOns is List) {
      for (final rawAddOn in rawAddOns) {
        if (rawAddOn is! Map) continue;

        addOns.add(
          CartAddOn(
            id: rawAddOn['id']?.toString() ?? '',
            name: rawAddOn['name']?.toString() ?? '',
            price: _readDouble(rawAddOn['price']),
          ),
        );
      }
    }

    return CartItem(
      food: Food(
        id: _readInt(foodData['id']),
        name: foodData['name']?.toString() ?? '',
        image: foodData['image']?.toString() ?? '',
        rating: _readDouble(foodData['rating']),
        reviewCount: _readInt(foodData['reviewCount']),
        prepTimeMinutes: _readInt(foodData['prepTimeMinutes']),
        cookTimeMinutes: _readInt(foodData['cookTimeMinutes']),
        ingredients: _readStringList(foodData['ingredients']),
        tags: _readStringList(foodData['tags']),
        mealType: _readStringList(foodData['mealType']),
        price: _readDouble(foodData['price']),
      ),
      quantity: _readInt(raw['quantity'], fallback: 1),
      addOns: addOns,
    );
  }

  int _readInt(Object? value, {int fallback = 0}) {
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double _readDouble(Object? value) {
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  List<String> _readStringList(Object? value) {
    if (value is! List) return const [];

    return value.map((item) => item.toString()).toList();
  }
}
