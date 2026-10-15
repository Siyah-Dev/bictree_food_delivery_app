import 'package:food_delivery_app/features/cart/data/datasource/cart_local_data_source.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_item.dart';

class FakeCartLocalDataSource implements CartLocalDataSource {
  FakeCartLocalDataSource({List<CartItem> initialItems = const []})
    : _items = List<CartItem>.unmodifiable(initialItems);

  List<CartItem> _items;
  List<CartItem> savedItems = const [];

  @override
  List<CartItem> loadItems() => _items;

  @override
  Future<void> saveItems(List<CartItem> items) async {
    _items = List<CartItem>.unmodifiable(items);
    savedItems = _items;
  }
}
