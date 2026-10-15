import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cart/presentation/providers/cart_providers.dart';
import 'confirm_order_state.dart';

class ConfirmOrderController extends Notifier<ConfirmOrderState> {
  @override
  ConfirmOrderState build() => const ConfirmOrderState();

  void updateShippingAddress(String address) {
    final normalized = address.trim();
    if (normalized.isEmpty || normalized == state.shippingAddress) return;

    state = state.copyWith(shippingAddress: normalized);
  }

  bool placeOrder() {
    if (ref.read(cartControllerProvider).isEmpty) return false;

    ref.read(cartControllerProvider.notifier).clear();
    state = const ConfirmOrderState();
    return true;
  }

  void reset() {
    state = const ConfirmOrderState();
  }
}
