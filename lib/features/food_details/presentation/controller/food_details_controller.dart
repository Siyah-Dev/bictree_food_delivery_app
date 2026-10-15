import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cart/domain/entities/cart_item.dart';
import '../../../food/domain/entities/food.dart';
import 'food_details_state.dart';

const savouryAddOns = <CartAddOn>[
  CartAddOn(id: 'guacamole', name: 'Guacamole', price: 2.99),
  CartAddOn(id: 'jalapenos', name: 'Jalapeños', price: 3.99),
  CartAddOn(id: 'ground_beef', name: 'Ground Beef', price: 3.99),
  CartAddOn(id: 'pico_de_gallo', name: 'Pico de Gallo', price: 2.99),
];

const dessertAddOns = <CartAddOn>[
  CartAddOn(id: 'sliced_nuts', name: 'Sliced Nuts', price: 3.99),
  CartAddOn(id: 'whipped_cream', name: 'Whipped Cream', price: 1.00),
  CartAddOn(id: 'sliced_strawberries', name: 'Sliced Strawberries', price: 4.00),
  CartAddOn(id: 'lemon_zest', name: 'Lemon Zest', price: 1.25),
];

class FoodDetailsController extends Notifier<FoodDetailsState> {
  FoodDetailsController(this.food);

  final Food food;

  @override
  FoodDetailsState build() {
    final defaultAddOn = _isDessert ? 'whipped_cream' : 'jalapenos';
    return FoodDetailsState(
      food: food,
      selectedAddOnIds: {defaultAddOn},
    );
  }

  bool get _isDessert {
    final searchable = [food.name, ...food.tags, ...food.mealType]
        .join(' ')
        .toLowerCase();
    return searchable.contains('dessert') ||
        searchable.contains('cake') ||
        searchable.contains('cheesecake') ||
        searchable.contains('sweet');
  }

  String get addOnSectionTitle =>
      _isDessert ? 'Add on ingredients' : 'Toppings';

  List<CartAddOn> get availableAddOns =>
      _isDessert ? dessertAddOns : savouryAddOns;

  List<CartAddOn> get selectedAddOns => availableAddOns
      .where((addOn) => state.selectedAddOnIds.contains(addOn.id))
      .toList(growable: false);

  void increaseQuantity() {
    state = state.copyWith(quantity: state.quantity + 1);
  }

  void decreaseQuantity() {
    if (state.quantity <= 1) return;
    state = state.copyWith(quantity: state.quantity - 1);
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  void toggleAddOn(String addOnId) {
    final selected = Set<String>.of(state.selectedAddOnIds);
    if (!selected.add(addOnId)) {
      selected.remove(addOnId);
    }
    state = state.copyWith(selectedAddOnIds: selected);
  }

  double get selectedAddOnsTotal => selectedAddOns.fold<double>(
        0,
        (sum, addOn) => sum + addOn.price,
      );

  double get unitTotal => food.price + selectedAddOnsTotal;

  double get totalPrice => unitTotal * state.quantity;
}


