import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CartOrderSummary extends StatelessWidget {
  const CartOrderSummary({
    super.key,
    required this.subtotal,
    required this.taxAndFees,
    required this.delivery,
  });

  final double subtotal;
  final double taxAndFees;
  final double delivery;

  double get total => subtotal + taxAndFees + delivery;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(label: 'Subtotal', amount: subtotal),
        const SizedBox(height: 14),
        _SummaryRow(label: 'Tax and Fees', amount: taxAndFees),
        const SizedBox(height: 14),
        _SummaryRow(label: 'Delivery', amount: delivery),
        const SizedBox(height: 16),
        const _DottedDivider(),
        const SizedBox(height: 13),
        _SummaryRow(
          label: 'Total',
          amount: total,
          isTotal: true,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: AppColors.white,
      fontSize: isTotal ? 13 : 12.5,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
    );

    return Row(
      children: [
        Expanded(child: Text(label, style: textStyle)),
        Text('\$${amount.toStringAsFixed(2)}', style: textStyle),
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
          color: AppColors.white.withValues(alpha: 0.72),
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
