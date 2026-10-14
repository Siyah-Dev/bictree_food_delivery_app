import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class FingerprintButton extends StatelessWidget {
  const FingerprintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        color: AppColors.fingerprintBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.fingerprint,
        size: 31,
        color: AppColors.primary,
      ),
    );
  }
}