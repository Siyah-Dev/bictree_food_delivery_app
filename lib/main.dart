import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox<Map>('recipe_cache');
  await Hive.openBox<Map>('cart');

  runApp(const ProviderScope(child: FoodDeliveryApp()));
}
