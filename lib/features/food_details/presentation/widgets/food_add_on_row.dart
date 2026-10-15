import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cart/domain/entities/cart_item.dart';

class FoodAddOnRow extends StatelessWidget {
  const FoodAddOnRow({
    super.key,
    required this.addOn,
    required this.isSelected,
    required this.onTap,
  });

  final CartAddOn addOn;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Expanded(
              child: Text(
                addOn.name,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${addOn.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 14,
              height: 14,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: isSelected
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
