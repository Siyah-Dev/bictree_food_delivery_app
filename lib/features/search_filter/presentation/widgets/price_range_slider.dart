
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PriceRangeSlider extends StatelessWidget {
  const PriceRangeSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: const Color(0xFFD7D7D7),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.12),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 9,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 17,
            ),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: value.clamp(1, 100),
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: onChanged,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PriceTick('\$1'),
              _PriceTick('\$10'),
              _PriceTick('\$50'),
              _PriceTick('\$100 >'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceTick extends StatelessWidget {
  const _PriceTick(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}
