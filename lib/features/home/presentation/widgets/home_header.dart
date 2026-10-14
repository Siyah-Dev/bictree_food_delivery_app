
import 'package:flutter/material.dart';
import 'package:food_delivery_app/shared/presentation/widgets/food_search_header.dart';

import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.onCartTap,
    required this.onNotificationTap,
    required this.onProfileTap,
  });

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
      padding: EdgeInsets.fromLTRB(34, topInset + 22, 34, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FoodSearchHeader(
            onSearchTap: onSearchTap,
            onFilterTap: onFilterTap,
            onCartTap: onCartTap,
            onNotificationTap: onNotificationTap,
            onProfileTap: onProfileTap,
          ),
          const SizedBox(height: 16),
          const Text(
            'Good Morning',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 27,
              height: 1.05,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            "Rise And Shine! It's Breakfast Time",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              height: 1.1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
