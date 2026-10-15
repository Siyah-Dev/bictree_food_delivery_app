import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({
    super.key,
    required this.onBrowseMenu,
  });

  final VoidCallback onBrowseMenu;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 58,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(height: 18),
            const Text(
              'Your cart is empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add something delicious to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.88),
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: onBrowseMenu,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.headerYellow,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Browse Menu',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
