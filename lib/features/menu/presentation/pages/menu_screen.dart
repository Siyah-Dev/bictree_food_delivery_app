import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/app/route_names.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_snackbar.dart';
import '../../../food/domain/entities/food.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';
import '../../presentation/providers/menu_providers.dart';
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
        break;

      case _MenuSort.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case _MenuSort.name:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;

      case _MenuSort.cookingTime:
        result.sort((a, b) => a.totalTimeMinutes.compareTo(b.totalTimeMinutes));
        break;
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
                ..._MenuSort.values.map(
                  (option) => RadioListTile<_MenuSort>(
                    value: option,
                    groupValue: _sort,
                    activeColor: AppColors.primary,
                    title: Text(option.label),
                    onChanged: (value) => Navigator.pop(context, value),
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

  @override
  Widget build(BuildContext context) {
    final foodsAsync = ref.watch(menuFoodsProvider);

    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            MenuHeader(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
              },
              onSearchTap: () => _showMessage('Search is coming next.'),
              onFilterTap: () => _showMessage('Search and Filter is next.'),
              onCartTap: () => _showMessage('Cart is coming next.'),
              onNotificationTap: () => _showMessage('Notifications are outside this task.'),
              onProfileTap: () => _showMessage('Profile is outside this task.'),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: foodsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator(color:AppColors.primary)),
                  error: (error, stackTrace) =>
                      _MenuError(onRetry: () => ref.invalidate(menuFoodsProvider)),
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
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigation(selectedIndex: 1, onItemSelected: _onNavigationTap),
    );
  }

  List<Widget> _buildFoodList(List<Food> foods) {
    final widgets = <Widget>[];

    for (var index = 0; index < foods.length; index++) {
      final food = foods[index];

      widgets.add(
        MenuFoodCard(
          food: food,
          onTap: () => _showMessage('${food.name} details are coming next.'),
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

class _MenuError extends StatelessWidget {
  const _MenuError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text(
              'Unable to load recipes',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
