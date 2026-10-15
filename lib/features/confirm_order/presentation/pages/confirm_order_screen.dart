import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/core/widgets/app_primary_button.dart';
import 'package:food_delivery_app/features/confirm_order/presentation/widgets/edit_shipping_address_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/constants/cart_pricing.dart';
import '../../../cart/presentation/controller/cart_controller.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../cart/presentation/widgets/cart_drawer.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';
import '../providers/confirm_order_providers.dart';
import '../widgets/confirm_order_header.dart';
import '../widgets/confirm_order_item_tile.dart';
import '../widgets/confirm_order_price_summary.dart';
import '../widgets/confirm_order_section_header.dart';
import '../widgets/empty_confirm_order.dart';
import '../widgets/shipping_address_section.dart';

class ConfirmOrderScreen extends ConsumerWidget {
  const ConfirmOrderScreen({super.key});

  Future<void> _editShippingAddress(
  BuildContext context,
  WidgetRef ref,
  String currentAddress,
) async {
  final updatedAddress = await showDialog<String>(
    context: context,
    builder: (_) => EditShippingAddressDialog(
      initialAddress: currentAddress,
    ),
  );

  if (updatedAddress == null || !context.mounted) {
    return;
  }

  ref
      .read(confirmOrderControllerProvider.notifier)
      .updateShippingAddress(updatedAddress);
}

  Future<void> _editOrder(BuildContext context) async {
    await CartDrawer.show(
      context,
      onCheckout: () {
      },
      onBrowseMenu: () => context.go(RouteNames.menu),
    );
  }

  Future<void> _removeItem(
    BuildContext context,
    CartItem item,
    CartController controller,
  ) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Remove item?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Remove ${item.food.name} from your order?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Remove',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (shouldRemove == true) {
      controller.removeItem(item.configurationKey);
    }
  }

  Future<void> _placeOrder(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final cartState = ref.read(cartControllerProvider);

    if (cartState.isEmpty) {
      AppSnackBar.error(
        context,
        message: 'Add at least one item before placing your order.',
      );
      return;
    }

    final shouldPlaceOrder = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text(
          'Place Order',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Confirm your order total of '
          '\$${(cartState.subtotal + CartPricing.taxAndFees + CartPricing.delivery).toStringAsFixed(2)}? '
          'This demo will place the order locally without a payment API.',
          style: const TextStyle(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Review'),
          ),
          AppPrimaryButton(onPressed:()=>  Navigator.of(dialogContext).pop(true), isLoading: false, label: 'Confirm'),
          
        ],
      ),
    );

    if (shouldPlaceOrder != true || !context.mounted) return;

    final placed = ref
        .read(confirmOrderControllerProvider.notifier)
        .placeOrder();

    if (!placed) {
      AppSnackBar.error(
        context,
        message: 'Your cart is empty.',
      );
      return;
    }

    AppSnackBar.success(
      context,
      message: 'Order placed successfully!',
    );
    context.go(RouteNames.home);
  }

  void _onNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        return;
      case 1:
        context.go(RouteNames.menu);
        return;
      case 2:
        AppSnackBar.show(context, message: 'Favorites are coming soon.');
        return;
      case 3:
        AppSnackBar.show(context, message: 'Orders are outside this task.');
        return;
      case 4:
        AppSnackBar.show(context, message: 'Support is outside this task.');
        return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final cartController = ref.read(cartControllerProvider.notifier);
    final confirmState = ref.watch(confirmOrderControllerProvider);
   
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: Stack(
        children: [
          const Positioned.fill(
            child: ColoredBox(color: AppColors.headerYellow),
          ),
          Positioned(
            top: topInset + 72,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: cartState.isEmpty
                  ? EmptyConfirmOrder(
                      onBrowseMenu: () => context.go(RouteNames.menu),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShippingAddressSection(
                            address: confirmState.shippingAddress,
                            onEdit: () => _editShippingAddress(
                              context,
                             ref,
                             confirmState.shippingAddress,

                            ),
                          ),
                          const SizedBox(height: 25),
                          ConfirmOrderSectionHeader(
                            title: 'Order Summary',
                            actionLabel: 'Edit',
                            onAction: () => _editOrder(context),
                          ),
                          const SizedBox(height: 12),
                          ...cartState.items.map((item) {
                            return Column(
                              children: [
                                ConfirmOrderItemTile(
                                  item: item,
                                  onDecrease: () => cartController.decrement(
                                    item.configurationKey,
                                  ),
                                  onIncrease: () => cartController.increment(
                                    item.configurationKey,
                                  ),
                                  onRemove: () => _removeItem(
                                    context,
                                    item,
                                    cartController,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: AppColors.dividerColor,
                                  ),
                                ),
                              ],
                            );
                          }),
                          ConfirmOrderPriceSummary(
                            subtotal: cartState.subtotal,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 36,
                              child:AppPrimaryButton(onPressed: () => _placeOrder(context, ref), isLoading: false, label: 'Place Order', backgroundColor: AppColors.fingerprintBackground,
                              foregroundColor: AppColors.primary,),
                              
                              
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          Positioned(
            top: topInset + 12,
            left: 24,
            right: 24,
            child: ConfirmOrderHeader(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.home);
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: -1,
        onItemSelected: (index) => _onNavigationTap(context, index),
      ),
    );
  }
}
