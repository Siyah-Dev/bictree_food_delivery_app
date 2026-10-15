
import 'package:hive_flutter/hive_flutter.dart';

import '../model/food_model.dart';

class FoodLocalDataSource {
  FoodLocalDataSource(this._box);

  final Box<Map> _box;

  static const _firstPageFallbackKey = 'first_page_fallback';

  String _cacheKey({
    required int limit,
    required int skip,
  }) {
    return 'recipes_page_${limit}_$skip';
  }

  Future<void> savePage({
    required List<FoodModel> foods,
    required int limit,
    required int skip,
  }) async {
    final data = {
      'foods': foods.map((food) => food.toJson()).toList(),
    };

    await _box.put(
      _cacheKey(limit: limit, skip: skip),
      data,
    );

    if (skip == 0) {
      await _box.put(_firstPageFallbackKey, data);
    }
  }

  List<FoodModel>? getPage({
    required int limit,
    required int skip,
  }) {
    final exactPage = _box.get(
      _cacheKey(limit: limit, skip: skip),
    );

    final cached = exactPage ??
        (skip == 0 ? _box.get(_firstPageFallbackKey) : null);

    if (cached == null) return null;

    final records = cached['foods'];

    if (records is! List) return null;

    return records
        .whereType<Map>()
        .map(
          (item) => FoodModel.fromCache(
            Map<dynamic, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
