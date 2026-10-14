import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/menu/presentation/widgets/menu_error.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../food/domain/entities/food.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';
import '../providers/menu_providers.dart';
import '../widgets/menu_food_card.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_sort_row.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

enum _MenuSort {
  popular('Popular'),
  rating('Rating'),
  name('Name'),
  cookingTime('Cooking Time');

  const _MenuSort(this.label);

  final String label;
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String _selectedCategory = 'Snacks';
  _MenuSort _sort = _MenuSort.popular;

  final Set<int> _favoriteIds = {};

  // MenuHeader layout measurements.
  // Search top padding + search height + bottom spacing.
  static const double _headerSpacingBeforeCategories = 83;

  // Move the white panel upward behind the orange category section.
  static const double _bodyOverlap = 55;

  // Keep the sort row below the category labels.
  static const double _contentTopSpacing = 55;

  List<Food> _filterFoods(List<Food> foods) {
    final category = _selectedCategory.toLowerCase();

    return foods.where((food) {
      final tags = food.tags.map((tag) => tag.toLowerCase()).toList();

      final mealTypes = food.mealType.map((meal) => meal.toLowerCase()).toList();

      switch (category) {
        case 'snacks':
          return tags.any(
            (tag) => tag.contains('snack') || tag.contains('appetizer') || tag.contains('starter'),
          );

        case 'meal':
          return mealTypes.any((meal) => ['breakfast', 'lunch', 'dinner'].contains(meal));

        case 'vegan':
          return tags.any((tag) => tag.contains('vegan') || tag.contains('plant-based'));

        case 'dessert':
          return mealTypes.any((meal) => meal.contains('dessert')) ||
              tags.any((tag) => tag.contains('dessert') || tag.contains('sweet'));

        case 'drinks':
          return mealTypes.any((meal) => meal.contains('drink') || meal.contains('beverage')) ||
              tags.any((tag) => tag.contains('drink') || tag.contains('beverage'));

        default:
          return true;
      }
    }).toList();
  }

  List<Food> _sortFoods(List<Food> foods) {
    final result = [...foods];

    switch (_sort) {
      case _MenuSort.popular:
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));

      case _MenuSort.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));

      case _MenuSort.name:
        result.sort((a, b) => a.name.compareTo(b.name));

      case _MenuSort.cookingTime:
        result.sort((a, b) => a.totalTimeMinutes.compareTo(b.totalTimeMinutes));
    }

    return result;
  }

  Future<void> _showSortOptions() async {
    final selected = await showModalBottomSheet<_MenuSort>(
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
                RadioGroup<_MenuSort>(
                  groupValue: _sort,
                  onChanged: (value) {
                    if (value != null) {
                      Navigator.pop(context, value);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _MenuSort.values.map((option) { 
                      return RadioListTile<_MenuSort>(
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

    if (selected != null && mounted) {
      setState(() => _sort = selected);
    }
  }

  void _showMessage(String message) {
    AppSnackBar.show(context, message: message);
  }

  void _onNavigationTap(int index) {
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

    _showMessage(messages[index]);
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
  }

  @override
  Widget build(BuildContext context) {
    final foodsAsync = ref.watch(menuFoodsProvider);
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
                child: _buildFoodContent(foodsAsync),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MenuHeader(
              selectedCategory: _selectedCategory,
              onCategorySelected: _onCategorySelected,
              onSearchTap: () {
                _showMessage('Search is coming next.');
              },
              onFilterTap: () {
                _showMessage('Search and Filter is next.');
              },
              onCartTap: () {
                _showMessage('Cart is coming next.');
              },
              onNotificationTap: () {
                _showMessage('Notifications are outside this task.');
              },
              onProfileTap: () {
                _showMessage('Profile is outside this task.');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(selectedIndex: 1, onItemSelected: _onNavigationTap),
    );
  }

  Widget _buildFoodContent(AsyncValue<List<Food>> foodsAsync) {
    return foodsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (error, stackTrace) => MenuError(onRetry: () => ref.invalidate(menuFoodsProvider)),
      data: (foods) {
        final filteredFoods = _sortFoods(_filterFoods(foods));

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.refresh(menuFoodsProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(34, 20, 34, 24),
            children: [
              MenuSortRow(
                sortLabel: _sort.label,
                onSortTap: _showSortOptions,
                onFilterTap: _showSortOptions,
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
                ..._buildFoodList(filteredFoods),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFoodList(List<Food> foods) {
    final widgets = <Widget>[];

    for (var index = 0; index < foods.length; index++) {
      final food = foods[index];

      widgets.add(
        MenuFoodCard(
          food: food,
          onTap: () {
            _showMessage('${food.name} details are coming next.');
          },
          onFavoriteTap: () {
            setState(() {
              if (!_favoriteIds.add(food.id)) {
                _favoriteIds.remove(food.id);
              }
            });
          },
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
