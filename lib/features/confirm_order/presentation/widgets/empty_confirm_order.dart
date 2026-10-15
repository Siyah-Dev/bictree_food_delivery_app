import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class EmptyConfirmOrder extends StatelessWidget {
  const EmptyConfirmOrder({
    super.key,
    required this.onBrowseMenu,
  });

  final VoidCallback onBrowseMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 52,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add some food before confirming your order.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onBrowseMenu,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('Browse Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
