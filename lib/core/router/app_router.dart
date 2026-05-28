import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/details_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.details,
      name: AppRoutes.detailsName,
      builder: (_, __) => const DetailsPage(),
    ),
  ],
  errorBuilder: (_, state) =>
      Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
);
