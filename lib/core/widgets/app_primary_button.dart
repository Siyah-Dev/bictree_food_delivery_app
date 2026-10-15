import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
    this.width = 182,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final double width;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor??AppColors.primary,
          foregroundColor: foregroundColor??AppColors.white,
          disabledBackgroundColor:disabledBackgroundColor?? AppColors.fingerprintBackground,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: const StadiumBorder(),
        ),
        child: isLoading
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}
