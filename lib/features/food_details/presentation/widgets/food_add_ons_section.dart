import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cart/domain/entities/cart_item.dart';
import 'food_add_on_row.dart';

class FoodAddOnsSection extends StatelessWidget {
  const FoodAddOnsSection({
    super.key,
    required this.title,
    required this.addOns,
    required this.selectedIds,
    required this.onAddOnTap,
  });

  final String title;
  final List<CartAddOn> addOns;
  final Set<String> selectedIds;
  final ValueChanged<String> onAddOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            height: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        ...addOns.map(
          (addOn) => FoodAddOnRow(
            addOn: addOn,
            isSelected: selectedIds.contains(addOn.id),
            onTap: () => onAddOnTap(addOn.id),
          ),
        ),
      ],
    );
  }
}
