import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
  });

  final CartItem item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: CachedNetworkImage(
            imageUrl: item.food.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => const ColoredBox(
              color: AppColors.imagePlaceholder,
              child: SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const SizedBox(
              width: 60,
              height: 60,
              child: ColoredBox(
                color: AppColors.imagePlaceholder,
                child: Icon(
                  Icons.restaurant,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.food.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10.5,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${item.unitPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.9),
                  fontSize: 10,
                  height: 1.1,
                ),
              ),
              if (item.addOns.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  '${item.addOns.length} add-on${item.addOns.length == 1 ? '' : 's'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.78),
                    fontSize: 8.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _QuantityButton(
              icon: Icons.remove_rounded,
              tooltip: 'Decrease quantity',
              onPressed: onDecrease,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '${item.quantity}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _QuantityButton(
              icon: Icons.add_rounded,
              tooltip: 'Increase quantity',
              onPressed: onIncrease,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 15,
            height: 15,
            child: Icon(
              icon,
              size: 11,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
