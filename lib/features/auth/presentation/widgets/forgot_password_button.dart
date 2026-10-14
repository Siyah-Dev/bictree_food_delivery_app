import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';

class ForgotPasswordButton extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: null,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 0,
          ),
          minimumSize: Size.zero,
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forget Password',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}