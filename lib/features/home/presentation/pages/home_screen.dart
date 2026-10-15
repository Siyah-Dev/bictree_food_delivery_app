import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../shared/presentation/widgets/food_category_selector.dart';
import '../providers/home_providers.dart';
import '../widgets/empty_category.dart';
import '../widgets/food_card.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/home_error.dart';
import '../widgets/home_header.dart';
import '../widgets/home_loading.dart';
import '../widgets/promo_banner.dart';
import '../widgets/section_heading.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    AppSnackBar.show(context, message: message);
  }

  void _onNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        return;
      case 1:
        context.go(RouteNames.menu);
        return;
      case 2:
        _showMessage(context, 'Favorites will be available soon.');
        return;
      case 3:
        _showMessage(context, 'Orders screen is coming soon.');
        return;
      case 4:
        _showMessage(context, 'Support will be available soon.');
        return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeControllerProvider);
    final homeController = ref.read(homeControllerProvider.notifier);
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.headerYellow)),

          Positioned(
            top: topInset + 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
              ),
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  try {
                    await homeController.refreshFoods();
                  } catch (_) {
                    if (!context.mounted) return;

                    AppSnackBar.show(
                      context,
                      message: 'Unable to refresh foods. Please try again.',
                    );
                  }
                },
                child: homeAsync.when(
                  loading: () => const HomeLoading(),
                  error: (error, stackTrace) => HomeError(onRetry: homeController.refreshFoods),
                  data: (homeState) {
                    final visibleFoods = homeController.filterFoods(homeState);
                    final bestSellers = homeController.bestSellers(visibleFoods);
                    final recommended = homeController.recommended(visibleFoods);

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(35, 30, 34, 18),
                      children: [
                        FoodCategorySelector(
                          selectedCategory: homeState.selectedCategory,
                          onCategorySelected: homeController.toggleCategory,
                          style: FoodCategoryStyle.home,
                        ),
                        const SizedBox(height: 4),
                        const Divider(height: 1, thickness: 1, color: AppColors.dividerColor),
                        const SizedBox(height: 12),
                        SectionHeading(
                          title: 'Best Seller',
                          action: 'View All',
                          onActionTap: () => context.go(RouteNames.menu),
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
                                    onTap: () => context.push(RouteNames.foodDetails, extra: food),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 18),
                        const PromoBanner(),
                        const SizedBox(height: 18),
                        const SectionHeading(title: 'Recommend', action: null, onActionTap: null),
                        const SizedBox(height: 12),
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
                                onTap: () => context.push(RouteNames.foodDetails, extra: food),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HomeHeader(
              onSearchTap: () => context.push(RouteNames.searchFilter),
              onFilterTap: () => context.push(RouteNames.searchFilter),
              onCartTap: () => _showMessage(context, 'Cart screen is coming next.'),
              onNotificationTap: () =>
                  _showMessage(context, 'Notifications are outside this task.'),
              onProfileTap: () => _showMessage(context, 'Profile is outside this task.'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: 0,
        onItemSelected: (index) => _onNavigationTap(context, index),
      ),
    );
  }
}
