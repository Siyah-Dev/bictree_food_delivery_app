import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/food/domain/entities/food.dart';
import 'package:food_delivery_app/features/food_details/presentation/controller/food_details_controller.dart';
import 'package:food_delivery_app/features/food_details/presentation/controller/food_details_state.dart';

final foodDetailsControllerProvider =
    NotifierProvider.autoDispose.family<FoodDetailsController, FoodDetailsState, Food>(
  FoodDetailsController.new,
);