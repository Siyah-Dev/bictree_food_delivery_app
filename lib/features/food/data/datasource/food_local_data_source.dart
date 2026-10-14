
import 'package:hive_flutter/hive_flutter.dart';

import '../model/food_model.dart';

class FoodLocalDataSource {
  FoodLocalDataSource(this._box);

  final Box<Map> _box;

  static const _firstPageKey = 'first_page';

  Future<void> saveFirstPage(List<FoodModel> foods) async {
    await _box.put(
      _firstPageKey,
      {
        'foods': foods.map((food) => food.toJson()).toList(),
      },
    );
  }

  List<FoodModel>? getFirstPage() {
    final cached = _box.get(_firstPageKey);

    if (cached == null) return null;

    final records = cached['foods'];

    if (records is! List) return null;

    return records
        .map(
          (item) => FoodModel.fromCache(
            Map<dynamic, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
