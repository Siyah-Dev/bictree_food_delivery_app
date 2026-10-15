import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cart/domain/entities/cart_item.dart';

class ConfirmOrderItemTile extends StatelessWidget {
  const ConfirmOrderItemTile({
    super.key,
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: CachedNetworkImage(
            imageUrl: item.food.image,
            width: 58,
            height: 78,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              width: 58,
              height: 78,
              child: ColoredBox(
                color: AppColors.imagePlaceholder,
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
            ),
            errorWidget: (context, url, error) => const SizedBox(
              width: 58,
              height: 78,
              child: ColoredBox(
                color: AppColors.imagePlaceholder,
                child: Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
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
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.food.totalTimeMinutes} min · '
                '${item.addOns.length} add-ons',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 7),
              Material(
                color: AppColors.fingerprintBackground,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Text(
                      'Cancel Order',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  SizedBox(
                    width: 21,
                    height: 21,
                    child: IconButton(
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      tooltip: 'Remove item',
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 13,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _QuantityButton(
                    icon: Icons.remove_rounded,
                    onTap: onDecrease,
                    enabled: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _QuantityButton(
                    icon: Icons.add_rounded,
                    onTap: onIncrease,
                    enabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primary : AppColors.fingerprintBackground,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 17,
          height: 17,
          child: Icon(
            icon,
            size: 12,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
