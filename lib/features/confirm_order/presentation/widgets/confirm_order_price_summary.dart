import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cart/presentation/constants/cart_pricing.dart';

class ConfirmOrderPriceSummary extends StatelessWidget {
  const ConfirmOrderPriceSummary({
    super.key,
    required this.subtotal,
  });

  final double subtotal;

  double get _taxAndFees => subtotal == 0 ? 0 : CartPricing.taxAndFees;
  double get _delivery => subtotal == 0 ? 0 : CartPricing.delivery;
  double get _total => subtotal + _taxAndFees + _delivery;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PriceRow(label: 'Subtotal', amount: subtotal),
        const SizedBox(height: 12),
        _PriceRow(label: 'Tax and Fees', amount: _taxAndFees),
        const SizedBox(height: 12),
        _PriceRow(label: 'Delivery', amount: _delivery),
        const SizedBox(height: 14),
        const _DottedDivider(),
        const SizedBox(height: 12),
        _PriceRow(
          label: 'Total',
          amount: _total,
          isTotal: true,
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: AppColors.textPrimary,
      fontSize: isTotal ? 14 : 13,
      fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text('\$${amount.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 1,
      child: CustomPaint(
        painter: _DottedLinePainter(
          color: AppColors.dividerColor,
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  const _DottedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 5) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + 2).clamp(0, size.width).toDouble(), size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
