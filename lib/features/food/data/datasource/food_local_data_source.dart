import 'package:hive_flutter/hive_flutter.dart';

import '../model/food_model.dart';

class FoodLocalDataSource {
  FoodLocalDataSource(this._box);

  final Box<Map> _box;

  String _cacheKey({required int limit, required int skip}) {
    return 'recipes_page_${limit}_$skip';
  }

  Future<void> savePage({
    required List<FoodModel> foods,
    required int limit,
    required int skip,
  }) async {
    await _box.put(_cacheKey(limit: limit, skip: skip), {
      'foods': foods.map((food) => food.toJson()).toList(),
    });
  }

  List<FoodModel>? getPage({required int limit, required int skip}) {
    final cached = _box.get(_cacheKey(limit: limit, skip: skip));

    if (cached == null) return null;

    final records = cached['foods'];

    if (records is! List) return null;

    return records
        .whereType<Map>()
        .map((item) => FoodModel.fromCache(Map<dynamic, dynamic>.from(item)))
        .toList();
  }
}
