
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';

import '../../../food/domain/entities/food.dart';

class MenuFoodCard extends StatelessWidget {
  const MenuFoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.onFavoriteTap,
  });

  final Food food;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  static const _orange = Color(0xFFF04E23);
  static const _text = Color(0xFF482D26);

  String get _description {
    if (food.ingredients.isEmpty) return food.name;

    final ingredients = food.ingredients.take(4).join(', ');
    return ingredients.length > 85
        ? '${ingredients.substring(0, 82)}...'
        : ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.86,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: CachedNetworkImage(
                  imageUrl: food.image,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const ColoredBox(
                    color: Color(0xFFEDE5DF),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _orange,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => const ColoredBox(
                    color: Color(0xFFEDE5DF),
                    child: Center(
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: _text,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 16,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                _RatingBadge(rating: food.rating),
                const SizedBox(width: 8),
                Text(
                  '\$${food.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: _orange,
                    fontSize: 15,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              _description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF766963),
                fontSize: 10,
                height: 1.25,
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFD65A),
            size: 10,
          ),
        ],
      ),
    );
  }
}
