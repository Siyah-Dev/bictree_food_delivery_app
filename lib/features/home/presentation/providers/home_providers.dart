import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/home/presentation/controller/home_state.dart';

import '../controller/home_controller.dart';

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomeState>(HomeController.new);
