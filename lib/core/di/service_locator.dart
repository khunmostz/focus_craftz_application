import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:focus_craftz_application/core/analytics/analytics_service.dart';
import 'package:focus_craftz_application/core/analytics/firebase_analytics_service.dart';

import 'package:focus_craftz_application/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:focus_craftz_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_out.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_up_with_email_password.dart';
import 'package:focus_craftz_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focus_craftz_application/features/home/data/datasources/home_local_data_source.dart';
import 'package:focus_craftz_application/features/home/data/repositories/home_repository_impl.dart';
import 'package:focus_craftz_application/features/home/domain/repositories/home_repository.dart';
import 'package:focus_craftz_application/features/home/domain/usecases/get_welcome_message.dart';
import 'package:focus_craftz_application/features/home/presentation/bloc/home_bloc.dart';

final locator = GetIt.instance;

Future<void> initServiceLocator() async {
  // ─── External ───────────────────────────────────────────
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  locator.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  locator.registerLazySingleton<FirebaseCrashlytics>(() => FirebaseCrashlytics.instance);
  locator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // ─── Analytics / Crashlytics ─────────────────────────────
  locator.registerLazySingleton<AnalyticsService>(
    () => FirebaseAnalyticsService(
      analytics: locator<FirebaseAnalytics>(),
      crashlytics: locator<FirebaseCrashlytics>(),
    ),
  );

  // ─── Auth feature ────────────────────────────────────────
  locator.registerFactory(
    () => AuthBloc(
      authRepository: locator<AuthRepository>(),
      signInWithEmailPassword: locator<SignInWithEmailPassword>(),
      signUpWithEmailPassword: locator<SignUpWithEmailPassword>(),
      signInWithGoogle: locator<SignInWithGoogle>(),
      signOut: locator<SignOut>(),
      analyticsService: locator<AnalyticsService>(),
    ),
  );

  locator.registerLazySingleton(() => SignInWithEmailPassword(locator<AuthRepository>()));
  locator.registerLazySingleton(() => SignUpWithEmailPassword(locator<AuthRepository>()));
  locator.registerLazySingleton(() => SignInWithGoogle(locator<AuthRepository>()));
  locator.registerLazySingleton(() => SignOut(locator<AuthRepository>()));

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator(), locator(), locator()),
  );

  // ─── Home feature ────────────────────────────────────────
  locator.registerFactory(() => HomeBloc(getWelcomeMessage: locator()));
  locator.registerLazySingleton(() => GetWelcomeMessage(locator()));
  locator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<HomeLocalDataSource>(
    HomeLocalDataSourceImpl.new,
  );
}
