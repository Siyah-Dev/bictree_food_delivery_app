import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/cart/presentation/widgets/cart_drawer.dart';
import 'package:food_delivery_app/features/menu/presentation/controller/menu_state.dart';
import 'package:food_delivery_app/features/menu/presentation/widgets/menu_error.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../food/domain/entities/food.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';
import '../controller/menu_controller.dart' as menu_controller;
import '../providers/menu_providers.dart';
import '../widgets/menu_food_card.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_sort_row.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  static const double _headerSpacingBeforeCategories = 83;
  static const double _bodyOverlap = 55;
  static const double _contentTopSpacing = 55;

  Future<void> _showSortOptions(
    BuildContext context,
    MenuState menuState,
    menu_controller.MenuController menuController,
  ) async {
    final selected = await showModalBottomSheet<MenuSort>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.menuBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sort recipes by',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                RadioGroup<MenuSort>(
                  groupValue: menuState.sort,
                  onChanged: (value) {
                    if (value != null) {
                      Navigator.pop(context, value);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: MenuSort.values.map((option) {
                      return RadioListTile<MenuSort>(
                        value: option,
                        activeColor: AppColors.primary,
                        title: Text(option.label),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null && context.mounted) {
      menuController.selectSort(selected);
    }
  }

  void _showMessage(BuildContext context, String message) {
    AppSnackBar.show(context, message: message);
  }

  void _onNavigationTap(BuildContext context, int index) {
    if (index == 1) return;

    if (index == 0) {
      context.go(RouteNames.home);
      return;
    }

    const messages = [
      '',
      '',
      'Favorites are saved locally on this screen.',
      'Orders screen is coming soon.',
      'Support is outside this task.',
    ];

    _showMessage(context, messages[index]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuControllerProvider);
    final menuController = ref.read(menuControllerProvider.notifier);
    final topPadding = MediaQuery.paddingOf(context).top;

    final bodyTop = topPadding + _headerSpacingBeforeCategories + _bodyOverlap;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.headerYellow)),

          Positioned(
            top: bodyTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: _contentTopSpacing),
                child: _buildFoodContent(context, menuAsync, menuController),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MenuHeader(
              selectedCategory: menuAsync.hasValue
                  ? menuAsync.requireValue.selectedCategory
                  : 'Snacks',
              onCategorySelected: menuAsync.hasValue ? menuController.selectCategory : (_) {},
              onSearchTap: () {
                _showMessage(context, 'Search is coming next.');
              },
              onFilterTap: () {
                context.push(RouteNames.searchFilter);
              },
              onCartTap: () {
                CartDrawer.show(
                  context,
                  onCheckout: () {
                    AppSnackBar.show(context, message: 'Confirm Order screen is the next feature.');
                  },
                  onBrowseMenu: () => context.go(RouteNames.menu),
                );
              },
              onNotificationTap: () {
                _showMessage(context, 'Notifications are outside this task.');
              },
              onProfileTap: () {
                _showMessage(context, 'Profile is outside this task.');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: 1,
        onItemSelected: (index) => _onNavigationTap(context, index),
      ),
    );
  }

  Widget _buildFoodContent(
    BuildContext context,
    AsyncValue<MenuState> menuAsync,
    menu_controller.MenuController menuController,
  ) {
    return menuAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (error, stackTrace) => MenuError(onRetry: menuController.refreshFoods),
      data: (menuState) {
        final filteredFoods = menuController.filterAndSortFoods(menuState);

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            try {
              await menuController.refreshFoods();
            } catch (_) {
              if (!context.mounted) return;

              AppSnackBar.show(context, message: 'Unable to refresh foods. Please try again.');
            }
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(34, 20, 34, 24),
            children: [
              MenuSortRow(
                sortLabel: menuState.sort.label,
                onSortTap: () => _showSortOptions(context, menuState, menuController),
                onFilterTap: () => context.push(RouteNames.searchFilter),
              ),
              const SizedBox(height: 20),
              if (filteredFoods.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Text(
                      'No recipes found in this category.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                ..._buildFoodList(context, menuController, filteredFoods),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFoodList(
    BuildContext context,
    menu_controller.MenuController menuController,
    List<Food> foods,
  ) {
    final widgets = <Widget>[];

    for (var index = 0; index < foods.length; index++) {
      final food = foods[index];

      widgets.add(
        MenuFoodCard(
          food: food,
          onTap: () => context.push(RouteNames.foodDetails, extra: food),
          onFavoriteTap: () => menuController.toggleFavorite(food.id),
        ),
      );

      if (index < foods.length - 1) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, thickness: 0.7, color: AppColors.dividerColor),
          ),
        );
      }
    }

    return widgets;
  }
}
