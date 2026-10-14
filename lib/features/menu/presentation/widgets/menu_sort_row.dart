
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';

class MenuSortRow extends StatelessWidget {
  const MenuSortRow({
    super.key,
    required this.sortLabel,
    required this.onSortTap,
    required this.onFilterTap,
  });

  final String sortLabel;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Sort By',
          style: TextStyle(
            color: AppColors.sortLabel,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onSortTap,
          child: Text(
            sortLabel,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        Material(
          color: AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onFilterTap,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 22,
              height: 22,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: _FilterIcon(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterIcon extends StatelessWidget {
  const _FilterIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/header/filter.svg',
      colorFilter: const ColorFilter.mode(
        AppColors.white,
        BlendMode.srcIn,
      ),
    );
  }
}
