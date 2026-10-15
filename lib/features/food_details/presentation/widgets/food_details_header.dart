import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../food/domain/entities/food.dart';

class FoodDetailsHeader extends StatelessWidget {
  const FoodDetailsHeader({
    super.key,
    required this.food,
    required this.isFavorite,
    required this.onBack,
    required this.onFavoriteTap,
  });

  final Food food;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         IconButton(
    //           onPressed: onBack,
    //           padding: EdgeInsets.zero,
    //           constraints: const BoxConstraints.tightFor(width: 22, height: 26),
    //           icon: const Icon(Icons.chevron_left_rounded, size: 26, color: AppColors.primary),
    //         ),
    //         Text(
    //           food.name,
    //           maxLines: 1,
    //           overflow: TextOverflow.ellipsis,
    //           style: const TextStyle(
    //             color: AppColors.textPrimary,
    //             fontSize: 15,
    //             height: 1.25,
    //             fontWeight: FontWeight.w700,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    // );

    return Row(
      crossAxisAlignment: .center,
      children: [
        IconButton(
          onPressed: onBack,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 22, height: 26),
          icon: const Icon(Icons.chevron_left_rounded, size: 26, color: AppColors.primary),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              Text(
                food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      food.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 9,
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star_rounded, size: 10, color: AppColors.ratingStar),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onFavoriteTap,
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 16,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
