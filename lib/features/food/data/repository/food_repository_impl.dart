import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../domain/entities/food.dart';
import '../../domain/repository/food_repository.dart';
import '../datasource/food_local_data_source.dart';
import '../datasource/food_remote_data_source.dart';
import '../model/food_model.dart';

class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl({
    required FoodRemoteDataSource remoteDataSource,
    required FoodLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final FoodRemoteDataSource _remoteDataSource;
  final FoodLocalDataSource _localDataSource;

  @override
  Future<List<Food>> getFoods({int limit = 10, int skip = 0}) async {
    late final List<FoodModel> models;

    try {
      models = await _remoteDataSource.getFoods(limit: limit, skip: skip);
    } on DioException catch (networkError, stackTrace) {
      try {
        final cachedModels = _localDataSource.getPage(limit: limit, skip: skip);

        if (cachedModels != null) {
          return cachedModels.map((model) => model.toEntity()).toList();
        }
      } catch (cacheError, cacheStackTrace) {
        developer.log(
          'Failed to read cached recipes.',
          name: 'FoodRepository',
          error: cacheError,
          stackTrace: cacheStackTrace,
        );
      }

      Error.throwWithStackTrace(networkError, stackTrace);
    }

    // A cache write failure must not invalidate a successful API response.
    try {
      await _localDataSource.savePage(foods: models, limit: limit, skip: skip);
    } catch (error, stackTrace) {
      developer.log(
        'Failed to cache recipes.',
        name: 'FoodRepository',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return models.map((model) => model.toEntity()).toList();
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
