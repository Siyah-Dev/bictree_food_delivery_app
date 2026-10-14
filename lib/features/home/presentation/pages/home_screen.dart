import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/app/route_names.dart';
import 'package:food_delivery_app/core/utils/app_snackbar.dart';
import 'package:food_delivery_app/features/home/presentation/widgets/empty_category.dart';
import 'package:food_delivery_app/features/home/presentation/widgets/home_error.dart';
import 'package:food_delivery_app/features/home/presentation/widgets/home_loading.dart';
import 'package:food_delivery_app/features/home/presentation/widgets/section_heading.dart';
import 'package:food_delivery_app/shared/presentation/widgets/food_category_selector.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../food/domain/entities/food.dart';
import '../../../food/presentation/providers/food_providers.dart';
import '../widgets/food_card.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategory;

  List<Food> _filterFoods(List<Food> foods) {
    final category = _selectedCategory?.toLowerCase();

    if (category == null) return foods;

    return foods.where((food) {
      final tags = food.tags.map((tag) => tag.toLowerCase()).toList();
      final mealTypes = food.mealType.map((meal) => meal.toLowerCase()).toList();

      switch (category) {
        case 'snacks':
          return tags.any((tag) => tag.contains('snack') || tag.contains('appetizer'));

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

  List<Food> _bestSellers(List<Food> foods) {
    final sorted = [...foods]..sort((a, b) => b.rating.compareTo(a.rating));

    return sorted.take(4).toList();
  }

  List<Food> _recommended(List<Food> foods) {
    return foods.take(10).toList();
  }

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? null : category;
    });
  }

  void _onNavigationTap(int index) {
    if (index == 0) return;
    if (index == 1) {
      context.go(RouteNames.menu);
      return;
    }

    const messages = [
      '',
      'Menu screen is coming next.',
      'Favorites will be available soon.',
      'Orders screen is coming soon.',
      'Support will be available soon.',
    ];

    AppSnackBar.show(context, message: messages[index]);
  }

  @override
  Widget build(BuildContext context) {
    final foodsAsync = ref.watch(foodsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(
            onSearchTap: () => AppSnackBar.show(context, message: 'Search screen is coming next.'),

            onFilterTap: () =>context.push(RouteNames.searchFilter),
                
            onCartTap: () => AppSnackBar.show(context, message: 'Cart screen is coming next.'),
            onNotificationTap: () =>
                AppSnackBar.show(context, message: 'Notifications are outside this task.'),
            onProfileTap: () => AppSnackBar.show(context, message: 'Profile is outside this task.'),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.refresh(foodsProvider.future),
              child: foodsAsync.when(
                loading: () => const HomeLoading(),
                error: (error, stackTrace) =>
                    HomeError(onRetry: () => ref.invalidate(foodsProvider)),
                data: (foods) {
                  final filteredFoods = _filterFoods(foods);
                  final bestSellers = _bestSellers(filteredFoods);
                  final recommended = _recommended(filteredFoods);

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(35, 5, 34, 18),
                    children: [
                      const SizedBox(height: 10),
                      FoodCategorySelector(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _onCategoryTap,
                        style: FoodCategoryStyle.home,
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1, thickness: 1, color: AppColors.dividerColor),
                      const SizedBox(height: 12),
                      SectionHeading(
                        title: 'Best Seller',
                        action: 'View All',
                        onActionTap: () =>
                            AppSnackBar.show(context, message: 'Menu screen is coming next.'),
                      ),
                      const SizedBox(height: 10),
                      if (bestSellers.isEmpty)
                        const EmptyCategory()
                      else
                        SizedBox(
                          height: 109,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: bestSellers.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 11),
                            itemBuilder: (context, index) {
                              final food = bestSellers[index];

                              return SizedBox(
                                width: 73,
                                child: FoodCard(
                                  food: food,
                                  onTap: () => AppSnackBar.show(
                                    context,
                                    message: '${food.name} details will be implemented next.',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 18),
                      const PromoBanner(),
                      const SizedBox(height: 18),
                      SectionHeading(title: 'Recommend', action: null, onActionTap: null),
                      if (recommended.isEmpty)
                        const EmptyCategory()
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recommended.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.12,
                          ),
                          itemBuilder: (context, index) {
                            final food = recommended[index];

                            return FoodCard(
                              food: food,
                              isRecommended: true,
                              onTap: () => AppSnackBar.show(
                                context,
                                message: '${food.name} details will be implemented next.',
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(selectedIndex: 0, onItemSelected: _onNavigationTap),
    );
  }
}
