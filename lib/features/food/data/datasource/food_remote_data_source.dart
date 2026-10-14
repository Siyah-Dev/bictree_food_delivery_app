
import 'package:dio/dio.dart';
import 'package:food_delivery_app/core/constants/api_end_points.dart';

import '../model/food_model.dart';

class FoodRemoteDataSource {
  FoodRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<FoodModel>> getFoods({
    required int limit,
    required int skip,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.recipes,
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
    );

    final recipes = response.data?['recipes'];

    if (recipes is! List) {
      throw const FormatException(
        'Invalid recipe response from server.',
      );
    }

    return recipes
        .map(
          (item) => FoodModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<List<FoodModel>> searchFoods(String query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.searchRecipes,
      queryParameters: {'q': query},
    );

    final recipes = response.data?['recipes'];

    if (recipes is! List) {
      throw const FormatException(
        'Invalid search response from server.',
      );
    }

    return recipes
        .map(
          (item) => FoodModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<FoodModel> getFoodById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.recipeDetails(id),
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException(
        'Food details were not returned by the server.',
      );
    }

    return FoodModel.fromJson(data);
  }
}
