
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 128,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 11,
                  child: Container(
                    color: AppColors.primary,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          top: -17,
                          right: -8,
                          child: _DecorationCircle(size: 45),
                        ),
                        Positioned(
                          bottom: -19,
                          left: -8,
                          child: _DecorationCircle(size: 42),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Experience our\ndelicious new dish',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 8),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '30% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 29,
                                    height: 1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Image.asset(
                    'assets/images/promo_pizza.webp',
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PageIndicator(),
            SizedBox(width: 4),
            _PageIndicator(),
            SizedBox(width: 4),
            _PageIndicator(isActive: true),
            SizedBox(width: 4),
            _PageIndicator(),
            SizedBox(width: 4),
            _PageIndicator(),
          ],
        ),
      ],
    );
  }
}

class _DecorationCircle extends StatelessWidget {
  const _DecorationCircle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.headerYellow,
          width: 8,
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: isActive ? 20 : 15,
      height: 4,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : const Color(0xFFF0E3A4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
