import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/cart_controller.dart';
import '../controller/cart_state.dart';

final cartControllerProvider =
    NotifierProvider<CartController, CartState>(CartController.new);
