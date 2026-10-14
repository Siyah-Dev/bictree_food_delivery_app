import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:food_delivery_app/features/menu/presentation/pages/menu_screen.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_screen.dart';
import '../features/home/presentation/pages/home_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<int>(0);

  ref.listen(authControllerProvider, (_, _) {
    refreshNotifier.value++;
  });

  final router = GoRouter(
    initialLocation: RouteNames.login,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      // Wait until the initial session check completes.
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value ?? false;
      final isLoggingIn = state.matchedLocation == RouteNames.login;

      if (!isLoggedIn && !isLoggingIn) {
        return RouteNames.login;
      }

      if (isLoggedIn && isLoggingIn) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
  path: RouteNames.menu,
  name: 'menu',
  builder: (context, state) => const MenuScreen(),
),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refreshNotifier.dispose();
  });

  return router;
});
