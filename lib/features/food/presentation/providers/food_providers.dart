
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasource/food_local_data_source.dart';
import '../../data/datasource/food_remote_data_source.dart';
import '../../data/repository/food_repository_impl.dart';
import '../../domain/entities/food.dart';
import '../../domain/repository/food_repository.dart';

final foodRemoteDataSourceProvider =
    Provider<FoodRemoteDataSource>((ref) {
  return FoodRemoteDataSource(ref.watch(dioProvider));
});

final foodLocalDataSourceProvider =
    Provider<FoodLocalDataSource>((ref) {
  return FoodLocalDataSource(
    Hive.box<Map>('recipe_cache'),
  );
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(
    remoteDataSource: ref.watch(foodRemoteDataSourceProvider),
    localDataSource: ref.watch(foodLocalDataSourceProvider),
  );
});

final foodsProvider =
    FutureProvider.autoDispose<List<Food>>((ref) {
  return ref.watch(foodRepositoryProvider).getFoods(
        limit: 10,
        skip: 0,
      );
});
