
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

class FilterScreenHeader extends StatelessWidget {
  const FilterScreenHeader({
    super.key,
    required this.onBack,
    required this.onCartTap,
    required this.onProfileTap,
  });

  final VoidCallback onBack;
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      color: AppColors.headerYellow,
      padding: EdgeInsets.fromLTRB(22, topInset + 8, 22, 20),
      child: SizedBox(
        height: 42,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Text(
                'Filter',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 36,
                ),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary,
                  size: 17,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HeaderAction(
                    asset: 'assets/icons/header/cart.svg',
                    onTap: onCartTap,
                  ),
                  const SizedBox(width: 8),
                  _HeaderAction(
                    asset: 'assets/icons/header/profile.svg',
                    onTap: onProfileTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.asset,
    required this.onTap,
  });

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 27,
          height: 27,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
