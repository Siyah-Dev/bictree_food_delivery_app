
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/shared/models/food_category.dart';

import '../../../../core/theme/app_colors.dart';

enum FoodCategoryStyle {
  home,
  menu,
}

class FoodCategorySelector extends StatelessWidget {
  const FoodCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.style = FoodCategoryStyle.home,
  });

  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final FoodCategoryStyle style;

  static const Color _orange = AppColors.primary;
  static const Color _cream = AppColors.inputBackground;
  static const Color _pageBackground = AppColors.background;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case FoodCategoryStyle.home:
        return _buildHomeStyle();

      case FoodCategoryStyle.menu:
        return _buildMenuStyle();
    }
  }

  Widget _buildHomeStyle() {
    return SizedBox(
      height: 89,
      child: Row(
        children: FoodCategories.all.map((category) {
          final isSelected = selectedCategory == category.name;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onCategorySelected(category.name),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 52,
                    height: 61,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.categorySelected
                          : _cream,
                      borderRadius: BorderRadius.circular(28),
                      border: isSelected
                          ? Border.all(
                              color: _orange,
                              width: 1.2,
                            )
                          : null,
                    ),
                    child: SvgPicture.asset(
                      category.asset,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

 
  
Widget _buildMenuStyle() {
  const double sectionHeight = 96;
  const double selectedTop = 14;
  const double selectedWidth = 58;

  return Container(
    height: sectionHeight,
    color: _orange,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: FoodCategories.all.map((category) {
        final isSelected = selectedCategory == category.name;

        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onCategorySelected(category.name),
            child: SizedBox(
              height: sectionHeight,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
             
                  if (isSelected)
                    Positioned(
                      top: selectedTop,
                      bottom: 0,
                      child: SizedBox(
                        width: selectedWidth,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            color: _pageBackground,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 23,
                    child: Container(
                      width: 43,
                      height: 43,
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: _cream,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        category.asset,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 68,
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

}

