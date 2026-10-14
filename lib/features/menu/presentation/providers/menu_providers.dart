
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../food/domain/entities/food.dart';
import '../../../food/presentation/providers/food_providers.dart';

final menuFoodsProvider = FutureProvider.autoDispose<List<Food>>((ref) {
  return ref.watch(foodRepositoryProvider).getFoods(
        limit: 50,
        skip: 0,
      );
});
