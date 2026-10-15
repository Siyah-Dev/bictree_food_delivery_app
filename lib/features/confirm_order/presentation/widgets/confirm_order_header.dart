import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ConfirmOrderHeader extends StatelessWidget {
  const ConfirmOrderHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Confirm Order',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 28,
                height: 36,
              ),
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.primary,
                size: 27,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
