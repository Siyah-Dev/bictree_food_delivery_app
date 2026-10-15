import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({
    super.key,
    required this.address,
    required this.onEdit,
  });

  final String address;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Shipping Address',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              onPressed: onEdit,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints.tightFor(
                width: 30,
                height: 30,
              ),
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.accent,
                size: 17,
              ),
              tooltip: 'Edit shipping address',
            ),
          ],
        ),
        const SizedBox(height: 7),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
