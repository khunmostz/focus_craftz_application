import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:focus_craftz_application/features/auth/presentation/pages/auth_page.dart';
import 'package:focus_craftz_application/features/home/presentation/pages/details_page.dart';
import 'package:focus_craftz_application/features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute = state.matchedLocation == AppRoutes.login;

    if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
    if (isLoggedIn && isAuthRoute) return AppRoutes.home;
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (_, _) => const AuthPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (_, _) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.details,
      name: AppRoutes.detailsName,
      builder: (_, _) => const DetailsPage(),
    ),
  ],
  errorBuilder: (_, state) =>
      Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
);
