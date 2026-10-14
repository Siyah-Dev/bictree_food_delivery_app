
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RatingSortSelector extends StatelessWidget {
  const RatingSortSelector({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  final int rating;
  final ValueChanged<int> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Top Rated',
          style: TextStyle(
            color: AppColors.sortLabel,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              final starRating = index + 1;
              final selected = starRating <= rating;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onRatingChanged(starRating),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Icon(
                      selected
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 22,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
