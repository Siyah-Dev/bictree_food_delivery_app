import '../../../food/domain/entities/food.dart';

class CartAddOn {
  const CartAddOn({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final double price;
}

class CartItem {
  CartItem({
    required this.food,
    required this.quantity,
    List<CartAddOn> addOns = const [],
  }) : addOns = List.unmodifiable(addOns);

  final Food food;
  final int quantity;
  final List<CartAddOn> addOns;

  String get configurationKey {
    final addOnIds = addOns.map((addOn) => addOn.id).toList()..sort();
    return '${food.id}:${addOnIds.join('|')}';
  }

  double get unitPrice =>
      food.price + addOns.fold<double>(0, (sum, addOn) => sum + addOn.price);

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      food: food,
      quantity: quantity ?? this.quantity,
      addOns: addOns,
    );
  }
}
