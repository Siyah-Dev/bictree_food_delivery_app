
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/shared/models/food_category.dart';

import '../../../../core/theme/app_colors.dart';

class FoodCategory {
  const FoodCategory({
    required this.name,
    required this.asset,
  });

  final String name;
  final String asset;
}

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  final String? selectedCategory;
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 89,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: FoodCategories.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = FoodCategories.all[index];
          final isSelected = selectedCategory == category.name;

          return SizedBox(
            width: 52,
            child: InkWell(
              onTap: () => onCategoryTap(category.name),
              borderRadius: BorderRadius.circular(30),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 52,
                    height: 61,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.categorySelected
                          : AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(28),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primary,
                              width: 1.2,
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      category.asset,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    maxLines: 1,
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
        },
      ),
    );
  }
}
