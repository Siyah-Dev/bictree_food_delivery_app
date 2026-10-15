import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/features/food/data/datasource/food_local_data_source.dart';
import 'package:food_delivery_app/features/food/data/datasource/food_remote_data_source.dart';
import 'package:food_delivery_app/features/food/data/model/food_model.dart';
import 'package:food_delivery_app/features/food/data/repository/food_repository_impl.dart';
import 'package:food_delivery_app/features/food/domain/entities/food.dart';

void main() {
  group('FoodRepositoryImpl', () {
    late _FakeFoodRemoteDataSource remoteDataSource;
    late _FakeFoodLocalDataSource localDataSource;
    late FoodRepositoryImpl repository;

    setUp(() {
      remoteDataSource = _FakeFoodRemoteDataSource();
      localDataSource = _FakeFoodLocalDataSource();
      repository = FoodRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );
    });

    test('returns remote foods and caches the requested page', () async {
      remoteDataSource.foods = [_foodModel(id: 1, name: 'Fresh bowl')];

      final result = await repository.getFoods(limit: 10, skip: 0);

      expect(result, hasLength(1));
      expect(result.single, isA<Food>());
      expect(result.single.name, 'Fresh bowl');
      expect(localDataSource.pages['10:0']?.single.name, 'Fresh bowl');
      expect(localDataSource.fallbackFirstPage?.single.name, 'Fresh bowl');
    });

    test('returns cached first-page foods when the network fails', () async {
      remoteDataSource.failure = DioException(
        requestOptions: RequestOptions(path: '/recipes'),
        type: DioExceptionType.connectionError,
      );
      localDataSource.fallbackFirstPage = [
        _foodModel(id: 8, name: 'Cached recipe'),
      ];

      // Request a 50-item page to exercise the first-page fallback when only
      // a differently sized first page is cached.
      final result = await repository.getFoods(limit: 50, skip: 0);

      expect(result, hasLength(1));
      expect(result.single.name, 'Cached recipe');
      expect(remoteDataSource.lastLimit, 50);
    });

    test('rethrows the network error when no cached page exists', () async {
      final networkError = DioException(
        requestOptions: RequestOptions(path: '/recipes'),
        type: DioExceptionType.connectionError,
      );
      remoteDataSource.failure = networkError;

      await expectLater(
        repository.getFoods(limit: 10, skip: 0),
        throwsA(isA<DioException>()),
      );
    });
  });
}

class _FakeFoodRemoteDataSource implements FoodRemoteDataSource {
  List<FoodModel> foods = [];
  Object? failure;
  int? lastLimit;

  @override
  Future<List<FoodModel>> getFoods({
    required int limit,
    required int skip,
  }) async {
    lastLimit = limit;
    if (failure != null) throw failure!;
    return foods;
  }

  @override
  Future<List<FoodModel>> searchFoods(String query) async {
    throw UnimplementedError();
  }

  @override
  Future<FoodModel> getFoodById(int id) async {
    throw UnimplementedError();
  }
}

class _FakeFoodLocalDataSource implements FoodLocalDataSource {
  final Map<String, List<FoodModel>> pages = {};
  List<FoodModel>? fallbackFirstPage;

  @override
  Future<void> savePage({
    required List<FoodModel> foods,
    required int limit,
    required int skip,
  }) async {
    pages['$limit:$skip'] = List<FoodModel>.of(foods);
    if (skip == 0) {
      fallbackFirstPage = List<FoodModel>.of(foods);
    }
  }

  @override
  List<FoodModel>? getPage({required int limit, required int skip}) {
    return pages['$limit:$skip'] ?? (skip == 0 ? fallbackFirstPage : null);
  }
}

FoodModel _foodModel({required int id, required String name}) {
  return FoodModel(
    id: id,
    name: name,
    image: '',
    rating: 4.5,
    reviewCount: 12,
    prepTimeMinutes: 5,
    cookTimeMinutes: 10,
    ingredients: const ['ingredient'],
    tags: const ['snack'],
    mealType: const ['Lunch'],
    price: 12,
  );
}
