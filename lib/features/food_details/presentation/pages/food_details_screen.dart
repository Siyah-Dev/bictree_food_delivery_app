
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/food_details/presentation/providers/food_details_providers.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../food/domain/entities/food.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';
import '../controller/food_details_controller.dart';
import '../controller/food_details_state.dart';
import '../widgets/food_add_ons_section.dart';
import '../widgets/food_details_header.dart';
import '../widgets/food_details_image.dart';
import '../widgets/food_price_quantity_row.dart';

class FoodDetailsScreen extends ConsumerWidget {
  const FoodDetailsScreen({
    super.key,
    required this.food,
  });

  final Food? food;

  void _onNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        return;
      case 1:
        context.go(RouteNames.menu);
        return;
      case 2:
        AppSnackBar.show(
          context,
          message: 'Favorites are coming soon.',
        );
        return;
      case 3:
        AppSnackBar.show(
          context,
          message: 'Orders are coming soon.',
        );
        return;
      case 4:
        AppSnackBar.show(
          context,
          message: 'Support is outside this task.',
        );
        return;
    }
  }

  void _addToCart(
    BuildContext context,
    WidgetRef ref,
    FoodDetailsController controller,
    FoodDetailsState state,
  ) {
    ref.read(cartControllerProvider.notifier).addItem(
          food: state.food,
          quantity: state.quantity,
          addOns: controller.selectedAddOns,
        );

    AppSnackBar.success(
      context,
      message: '${state.food.name} added to cart.',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFood = food;

    if (selectedFood == null) {
      return _buildUnavailableScreen(context);
    }

    final provider = foodDetailsControllerProvider(selectedFood);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const Positioned.fill(
            child: ColoredBox(
              color: AppColors.headerYellow,
            ),
          ),

          Positioned(
            top: topInset + 130,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  30,
                  28,
                  30,
                  28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FoodDetailsImage(
                      imageUrl: state.food.image,
                    ),
                    const SizedBox(height: 10),

                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.dividerColor,
                    ),
                    const SizedBox(height: 10),

                    FoodPriceQuantityRow(
                      price: state.food.price,
                      quantity: state.quantity,
                      onDecrease: controller.decreaseQuantity,
                      onIncrease: controller.increaseQuantity,
                    ),

                    const SizedBox(height: 10),

                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.dividerColor,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      _subtitle(state.food),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      _description(state.food),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 24),

                    FoodAddOnsSection(
                      title: controller.addOnSectionTitle,
                      addOns: controller.availableAddOns,
                      selectedIds: state.selectedAddOnIds,
                      onAddOnTap: controller.toggleAddOn,
                    ),

                    const SizedBox(height: 22),

                    Center(
                      child: SizedBox(
                        width: 178,
                        height: 37,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _addToCart(
                              context,
                              ref,
                              controller,
                              state,
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                          ),
                          label: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: topInset + 48,
            left: 24,
            right: 24,
            child: FoodDetailsHeader(
              food: state.food,
              isFavorite: state.isFavorite,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.home);
                }
              },
              onFavoriteTap: controller.toggleFavorite,
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: -1,
        onItemSelected: (index) {
          _onNavigationTap(context, index);
        },
      ),
    );
  }

  Widget _buildUnavailableScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 52,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Food details unavailable',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please select a food item from the menu '
                  'to view its details.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.go(RouteNames.menu);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Back to Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _subtitle(Food food) {
    if (food.tags.isNotEmpty) {
      return food.tags.take(3).join(' • ');
    }

    if (food.mealType.isNotEmpty) {
      return food.mealType.join(' • ');
    }

    return food.name;
  }

  String _description(Food food) {
    final ingredients = food.ingredients.take(3).join(', ');
    final cookingTime = food.totalTimeMinutes;

    if (ingredients.isEmpty) {
      return 'Ready in $cookingTime minutes.';
    }

    return 'Ingredients include $ingredients. '
        'Ready in $cookingTime minutes.';
  }
}
