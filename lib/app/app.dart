import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_craftz_application/core/di/service_locator.dart';

import 'package:focus_craftz_application/core/router/app_router.dart';
import 'package:focus_craftz_application/core/theme/app_colors.dart';
import 'package:focus_craftz_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focus_craftz_application/features/home/presentation/bloc/home_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => locator<AuthBloc>()..add(const AuthStarted()),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => locator<HomeBloc>()..add(const HomeStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'FocusCraftz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            surface: AppColors.background,
          ),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
