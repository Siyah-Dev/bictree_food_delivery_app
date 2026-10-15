import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/confirm_order/presentation/controller/confirm_order_controller.dart';

import '../controller/confirm_order_state.dart';

final confirmOrderControllerProvider =
    NotifierProvider<ConfirmOrderController, ConfirmOrderState>(
  ConfirmOrderController.new,
);
