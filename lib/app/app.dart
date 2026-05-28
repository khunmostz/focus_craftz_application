import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_craftz_application/core/di/service_locator.dart';

import '../core/router/app_router.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => locator<HomeBloc>()..add(const HomeStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'FocusCraftz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
