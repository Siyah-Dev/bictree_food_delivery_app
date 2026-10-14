
import 'package:dio/dio.dart';

import '../../domain/entities/food.dart';
import '../../domain/repository/food_repository.dart';
import '../datasource/food_local_data_source.dart';
import '../datasource/food_remote_data_source.dart';

class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl({
    required FoodRemoteDataSource remoteDataSource,
    required FoodLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final FoodRemoteDataSource _remoteDataSource;
  final FoodLocalDataSource _localDataSource;

  @override
  Future<List<Food>> getFoods({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final models = await _remoteDataSource.getFoods(
        limit: limit,
        skip: skip,
      );

      if (skip == 0) {
        await _localDataSource.saveFirstPage(models);
      }

      return models.map((model) => model.toEntity()).toList();
    } on DioException {
      if (skip == 0) {
        final cachedModels = _localDataSource.getFirstPage();

        if (cachedModels != null) {
          return cachedModels.map((model) => model.toEntity()).toList();
        }
      }

      rethrow;
    }
  }

  @override
  Future<List<Food>> searchFoods(String query) async {
    final models = await _remoteDataSource.searchFoods(query);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Food> getFoodById(int id) async {
    final model = await _remoteDataSource.getFoodById(id);

    return model.toEntity();
  }
}
