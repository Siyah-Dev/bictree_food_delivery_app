import '../../../food/domain/entities/food.dart';

class FoodDetailsState {
  FoodDetailsState({
    required this.food,
    this.quantity = 1,
    this.isFavorite = false,
    Set<String> selectedAddOnIds = const {},
  }) : selectedAddOnIds = Set.unmodifiable(selectedAddOnIds);

  final Food food;
  final int quantity;
  final bool isFavorite;
  final Set<String> selectedAddOnIds;

  FoodDetailsState copyWith({
    int? quantity,
    bool? isFavorite,
    Set<String>? selectedAddOnIds,
  }) {
    return FoodDetailsState(
      food: food,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      selectedAddOnIds: selectedAddOnIds ?? this.selectedAddOnIds,
    );
  }
}
