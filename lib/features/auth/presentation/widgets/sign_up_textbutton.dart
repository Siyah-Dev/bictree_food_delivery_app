import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';

class SignUpTextbutton extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: "Don't have an account? ",
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

