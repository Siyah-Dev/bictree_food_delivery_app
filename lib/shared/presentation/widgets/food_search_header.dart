import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

class FoodSearchHeader extends StatelessWidget {
  const FoodSearchHeader({
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
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 32,
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
                      style: TextStyle(color: AppColors.menuSearchHint, fontSize: 10),
                    ),
                  ),
                  GestureDetector(
                    onTap: onFilterTap,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: SvgPicture.asset(
                        'assets/icons/header/filter.svg',
                        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        _HeaderAction(asset: 'assets/icons/header/cart.svg', onTap: onCartTap),
        const SizedBox(width: 7),
        _HeaderAction(asset: 'assets/icons/header/notification.svg', onTap: onNotificationTap),
        const SizedBox(width: 7),
        _HeaderAction(asset: 'assets/icons/header/profile.svg', onTap: onProfileTap),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              asset,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
