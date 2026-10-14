import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(30),
      children: [
        SizedBox(height: 35),
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 12),
        Center(
          child: Text(
            'Preparing something delicious...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}