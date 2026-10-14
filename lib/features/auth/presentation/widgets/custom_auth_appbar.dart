import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class CustomAuthAppBar extends StatelessWidget {
  const new({
    super.key,
    required this.topInset,
  });

  final double topInset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            top: topInset + 9,
            child: IconButton(
              onPressed: () {
                if (context.canPop()) context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 17,
                color: AppColors.primary,
              ),
            ),
          ),
          Positioned(
            top: topInset + 14,
            left: 0,
            right: 0,
            child: const Text(
              'Hello!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}