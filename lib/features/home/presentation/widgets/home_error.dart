import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';

class HomeError extends StatelessWidget {
  const HomeError({super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(30),
      children: [
        const SizedBox(height: 60),
        const Icon(
          Icons.wifi_off_rounded,
          color: AppColors.textSecondary,
          size: 42,
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Unable to load recipes',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: OutlinedButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ),
      ],
    );
  }
}
