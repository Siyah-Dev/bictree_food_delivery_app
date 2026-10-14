
import 'package:flutter/material.dart';
import 'package:food_delivery_app/shared/presentation/widgets/food_category_selector.dart';
import 'package:food_delivery_app/shared/presentation/widgets/food_search_header.dart';

import '../../../../core/theme/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      color: AppColors.headerYellow,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              34,
              topInset + 28,
              34,
              27,
            ),
            child: FoodSearchHeader(
              onSearchTap: onSearchTap,
              onFilterTap: onFilterTap,
              onCartTap: onCartTap,
              onNotificationTap: onNotificationTap,
              onProfileTap: onProfileTap,
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(29),
            ),
            child: FoodCategorySelector(
              selectedCategory: selectedCategory,
              onCategorySelected: onCategorySelected,
              style: FoodCategoryStyle.menu,
            ),
          ),
        ],
      ),
    );
  }
}
