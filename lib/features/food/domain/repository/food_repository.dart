
import '../entities/food.dart';

abstract interface class FoodRepository {
  Future<List<Food>> getFoods({
    int limit = 10,
    int skip = 0,
  });

  Future<List<Food>> searchFoods(String query);

  Future<Food> getFoodById(int id);
}
