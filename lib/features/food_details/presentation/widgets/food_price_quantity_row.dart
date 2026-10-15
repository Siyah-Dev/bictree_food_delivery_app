import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class FoodPriceQuantityRow extends StatelessWidget {
  const FoodPriceQuantityRow({
    super.key,
    required this.price,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final double price;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 21,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _QuantityButton(
          icon: Icons.remove_rounded,
          enabled: quantity > 1,
          onTap: onDecrease,
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _QuantityButton(
          icon: Icons.add_rounded,
          onTap: onIncrease,
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
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
          width: 21,
          height: 21,
          child: Icon(icon, size: 15, color: AppColors.white),
        ),
      ),
    );
  }
}
