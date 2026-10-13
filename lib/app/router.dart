import 'package:food_delivery_app/features/home/presentation/pages/home_screen.dart';
import 'package:go_router/go_router.dart';


import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  routes: [
   
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);