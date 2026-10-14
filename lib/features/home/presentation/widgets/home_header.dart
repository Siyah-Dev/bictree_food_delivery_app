
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      height: 187,
      padding: EdgeInsets.fromLTRB(34, topInset + 38, 34, 15),
      decoration: const BoxDecoration(
        color: AppColors.headerYellow,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSearchTap,
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.only(left: 12, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: Color(0xFF8D8580),
                              fontSize: 10,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onFilterTap,
                          child: Container(
                            width: 21,
                            height: 21,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: SvgPicture.asset(
                                'assets/icons/header/filter.svg',
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _HeaderIcon(
                asset: 'assets/icons/header/cart.svg',
                onTap: onCartTap,
              ),
              const SizedBox(width: 7),
              _HeaderIcon(
                asset: 'assets/icons/header/notification.svg',
                onTap: onNotificationTap,
              ),
              const SizedBox(width: 7),
              _HeaderIcon(
                asset: 'assets/icons/header/profile.svg',
                onTap: onProfileTap,
              ),
            ],
          ),
          const SizedBox(height: 20),
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

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.asset,
    required this.onTap,
  });

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
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
