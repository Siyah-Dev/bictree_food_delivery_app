
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/menu/presentation/controller/menu_state.dart';

import '../controller/menu_controller.dart';

final menuControllerProvider =
    AsyncNotifierProvider<MenuController, MenuState>(MenuController.new);
