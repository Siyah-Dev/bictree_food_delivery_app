
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class FilterCategoryChips extends StatelessWidget {
  const FilterCategoryChips({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
  });

  final List<String> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 30,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        final selected = selectedOptions.contains(option);

        return Material(
          color: selected
              ? AppColors.primary
              : AppColors.fingerprintBackground,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => onSelectionChanged(option),
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  option,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? AppColors.white
                        : AppColors.accent,
                    fontSize: 12,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
