import 'package:food_delivery_app/features/food/domain/entities/food.dart';
import 'package:food_delivery_app/features/food/domain/repository/food_repository.dart';

class FakeFoodRepository implements FoodRepository {
  FakeFoodRepository(this.load);

  final Future<List<Food>> Function() load;

  @override
  Future<List<Food>> getFoods({int limit = 10, int skip = 0}) => load();

  @override
  Future<Food> getFoodById(int id) => throw UnimplementedError();

  @override
  Future<List<Food>> searchFoods(String query) => throw UnimplementedError();
}
