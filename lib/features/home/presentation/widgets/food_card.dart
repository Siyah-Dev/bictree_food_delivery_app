
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../food/domain/entities/food.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.isRecommended = false,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  final Food food;
  final VoidCallback onTap;
  final bool isRecommended;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isRecommended ? 19 : 16),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: food.image,
                fit: BoxFit.cover,
                placeholder: (_, _) => const ColoredBox(
                  color: Color(0xFFF1E5D5),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => const ColoredBox(
                  color: Color(0xFFF1E5D5),
                  child: Icon(
                    Icons.restaurant_rounded,
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (isRecommended)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _RatingBadge(rating: food.rating),
                ),
              if (isRecommended)
                Positioned(
                  top: 8,
                  left: 48,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 0,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    '\$${food.price.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Semantics(
                label:
                    '${food.name}, rating ${food.rating}, price ${food.price}',
                child: const SizedBox.expand(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFB72B),
            size: 12,
          ),
        ],
      ),
    );
  }
}
