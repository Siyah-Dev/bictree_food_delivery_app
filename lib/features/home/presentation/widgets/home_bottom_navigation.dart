
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  static const _assets = [
    'assets/icons/navigation/home.svg',
    'assets/icons/navigation/menu.svg',
    'assets/icons/navigation/favorites.svg',
    'assets/icons/navigation/orders.svg',
    'assets/icons/navigation/support.svg',
  ];

  static const _labels = [
    'Home',
    'Menu',
    'Favorites',
    'Orders',
    'Support',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(27),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 61,
          child: Row(
            children: List.generate(_assets.length, (index) {
              final isSelected = selectedIndex == index;

              return Expanded(
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: _labels[index],
                  child: InkWell(
                    onTap: () => onItemSelected(index),
                    child: Center(
                      child: SizedBox(
                        width: 27,
                        height: 27,
                        child: SvgPicture.asset(
                          _assets[index],
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withValues(
                              alpha: isSelected ? 1 : 0.9,
                            ),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
