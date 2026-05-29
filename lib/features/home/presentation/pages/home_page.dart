import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:focus_craftz_application/core/router/app_navigation.dart';
import 'package:focus_craftz_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focus_craftz_application/features/home/presentation/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusCraftz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
            onPressed: () {
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading || state is HomeInitial) {
                  return const CircularProgressIndicator();
                }

                if (state is HomeLoaded) {
                  return Text(
                    state.message,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  );
                }

                if (state is HomeError) {
                  return Text(
                    state.message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: context.openDetails,
              child: const Text('Open details'),
            ),
          ],
        ),
      ),
    );
  }
}
