import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:focus_craftz_application/core/analytics/analytics_service.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_out.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_up_with_email_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required SignInWithEmailPassword signInWithEmailPassword,
    required SignUpWithEmailPassword signUpWithEmailPassword,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
    required AnalyticsService analyticsService,
  })  : _authRepository = authRepository,
        _signInWithEmailPassword = signInWithEmailPassword,
        _signUpWithEmailPassword = signUpWithEmailPassword,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _analyticsService = analyticsService,
        super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<_AuthUserChanged>(_onUserChanged);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
    on<AuthSignOutRequested>(_onSignOut);
  }

  final AuthRepository _authRepository;
  final SignInWithEmailPassword _signInWithEmailPassword;
  final SignUpWithEmailPassword _signUpWithEmailPassword;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final AnalyticsService _analyticsService;

  StreamSubscription<AuthUser?>? _authStateSubscription;

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) => add(_AuthUserChanged(user)),
    );
  }

  void _onUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      unawaited(_analyticsService.setUserId(event.user!.uid));
      emit(AuthAuthenticated(event.user!));
    } else {
      unawaited(_analyticsService.setUserId(null));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithEmailPassword(
      SignInParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) {
        _analyticsService.addBreadcrumb('sign_in_failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        unawaited(
          _analyticsService.logEvent('login', parameters: {'method': 'email'}),
        );
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onSignUp(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signUpWithEmailPassword(
      SignUpParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) {
        _analyticsService.addBreadcrumb('sign_up_failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        unawaited(
          _analyticsService.logEvent('sign_up', parameters: {'method': 'email'}),
        );
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onGoogleSignIn(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithGoogle(const NoParams());
    result.fold(
      (failure) {
        _analyticsService.addBreadcrumb('google_sign_in_failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        unawaited(
          _analyticsService.logEvent('login', parameters: {'method': 'google'}),
        );
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut(const NoParams());
    unawaited(_analyticsService.setUserId(null));
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
