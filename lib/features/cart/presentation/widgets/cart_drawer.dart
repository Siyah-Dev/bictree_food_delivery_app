import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../constants/cart_pricing.dart';
import '../providers/cart_providers.dart';
import 'cart_empty_state.dart';
import 'cart_item_tile.dart';
import 'cart_order_summary.dart';

abstract final class CartDrawer {

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCheckout,
    required VoidCallback onBrowseMenu,
  }) {
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: 'Close cart',
      barrierColor: Colors.black.withValues(alpha: 0.20),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final screenWidth = MediaQuery.sizeOf(dialogContext).width;
        final drawerWidth = math.min(screenWidth * 0.82, 400.0).toDouble();

        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: drawerWidth,
            height: MediaQuery.sizeOf(dialogContext).height,
            child: _CartDrawerPanel(
              onCheckout: onCheckout,
              onBrowseMenu: onBrowseMenu,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}

class _CartDrawerPanel extends ConsumerWidget {
  const _CartDrawerPanel({
    required this.onCheckout,
    required this.onBrowseMenu,
  });

  final VoidCallback onCheckout;
  final VoidCallback onBrowseMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final cartController = ref.read(cartControllerProvider.notifier);
    final systemInsets = MediaQuery.paddingOf(context);

    return Material(
      color: AppColors.primary,
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.horizontal(left: Radius.circular(80)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          21,
          systemInsets.top + 17,
          21,
          systemInsets.bottom + 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _CartDrawerHeader(),
            const SizedBox(height: 25),
            const Divider(
              height: 1,
              thickness: 0.8,
              color: Color(0x99FFFFFF),
            ),
            const SizedBox(height: 13),
            Text(
              'You have ${cartState.totalQuantity} '
              '${cartState.totalQuantity == 1 ? 'item' : 'items'} in the cart',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 17),
            if (cartState.isEmpty)
              Expanded(
                child: CartEmptyState(
                  onBrowseMenu: () {
                    Navigator.of(context).pop();
                    onBrowseMenu();
                  },
                ),
              )
            else ...[
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: cartState.items.length,
                  physics: const ClampingScrollPhysics(),
                  separatorBuilder: (_, _) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 1,
                      thickness: 0.7,
                      color: Color(0x99FFFFFF),
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final item = cartState.items[index];
                    final key = item.configurationKey;

                    return CartItemTile(
                      item: item,
                      onDecrease: () => cartController.decrement(key),
                      onIncrease: () => cartController.increment(key),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              CartOrderSummary(
                subtotal: cartState.subtotal,
                taxAndFees: cartState.isEmpty ? 0 : CartPricing.taxAndFees,
                delivery: cartState.isEmpty ? 0 : CartPricing.delivery,
              ),
              const SizedBox(height: 37),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCheckout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.headerYellow,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
            ],
          ],
        ),
      ),
    );
  }
}

class _CartDrawerHeader extends StatelessWidget {
  const _CartDrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 9),
        const Text(
          'Cart',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
