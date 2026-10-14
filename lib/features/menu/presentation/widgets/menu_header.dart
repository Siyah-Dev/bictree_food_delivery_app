
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.onCartTap,
    required this.onNotificationTap,
    required this.onProfileTap,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final VoidCallback onCartTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;

  static const _categories = [
    _MenuCategory('Snacks', 'assets/icons/categories/snacks.svg'),
    _MenuCategory('Meal', 'assets/icons/categories/meals.svg'),
    _MenuCategory('Vegan', 'assets/icons/categories/vegan.svg'),
    _MenuCategory('Dessert', 'assets/icons/categories/desserts.svg'),
    _MenuCategory('Drinks', 'assets/icons/categories/drinks.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      color: AppColors.headerYellow,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(34, topPadding + 28, 34, 27),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onSearchTap,
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.only(left: 12, right: 5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: AppColors.menuSearchHint,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          _RoundHeaderAction(
                            asset: 'assets/icons/header/filter.svg',
                            onTap: onFilterTap,
                            filled: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 28),
                _RoundHeaderAction(
                  asset: 'assets/icons/header/cart.svg',
                  onTap: onCartTap,
                ),
                const SizedBox(width: 7),
                _RoundHeaderAction(
                  asset: 'assets/icons/header/notification.svg',
                  onTap: onNotificationTap,
                ),
                const SizedBox(width: 7),
                _RoundHeaderAction(
                  asset: 'assets/icons/header/profile.svg',
                  onTap: onProfileTap,
                ),
              ],
            ),
          ),
          Container(
            height: 110,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(29),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _categories.map((category) {
                final selected = category.name == selectedCategory;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onCategorySelected(category.name),
                    child: SizedBox(
                      height: 110,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          if (selected)
                            Positioned(
                              top: 15,
                              child: Container(
                                width: 70,
                                height: 82,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(27),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 26,
                            child: Column(
                              children: [
                                Container(
                                  width: 49,
                                  height: 49,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    category.asset,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 10,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCategory {
  const _MenuCategory(this.name, this.asset);

  final String name;
  final String asset;
}

class _RoundHeaderAction extends StatelessWidget {
  const _RoundHeaderAction({
    required this.asset,
    required this.onTap,
    this.filled = false,
  });

  final String asset;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : AppColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 23,
          height: 23,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SvgPicture.asset(
              asset,
              colorFilter: ColorFilter.mode(
                filled ? AppColors.white : AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
