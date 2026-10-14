import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';

class MenuError extends StatelessWidget {
  const MenuError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            const Text(
              'Unable to load recipes',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
