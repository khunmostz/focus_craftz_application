import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/analytics/analytics_service.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_out.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_up_with_email_password.dart';
import 'package:focus_craftz_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSignInWithEmailPassword extends Mock
    implements SignInWithEmailPassword {}

class MockSignUpWithEmailPassword extends Mock
    implements SignUpWithEmailPassword {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignOut extends Mock implements SignOut {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  setUpAll(() {
    registerFallbackValue(const SignInParams(email: '', password: ''));
    registerFallbackValue(const SignUpParams(email: '', password: ''));
    registerFallbackValue(const NoParams());
  });

  late MockAuthRepository mockRepository;
  late MockSignInWithEmailPassword mockSignIn;
  late MockSignUpWithEmailPassword mockSignUp;
  late MockSignInWithGoogle mockGoogleSignIn;
  late MockSignOut mockSignOut;
  late MockAnalyticsService mockAnalytics;

  const tAuthUser = AuthUser(uid: 'uid-1', email: 'test@test.com');
  const tEmail = 'test@test.com';
  const tPassword = 'password123';

  AuthBloc buildBloc() => AuthBloc(
        authRepository: mockRepository,
        signInWithEmailPassword: mockSignIn,
        signUpWithEmailPassword: mockSignUp,
        signInWithGoogle: mockGoogleSignIn,
        signOut: mockSignOut,
        analyticsService: mockAnalytics,
      );

  setUp(() {
    mockRepository = MockAuthRepository();
    mockSignIn = MockSignInWithEmailPassword();
    mockSignUp = MockSignUpWithEmailPassword();
    mockGoogleSignIn = MockSignInWithGoogle();
    mockSignOut = MockSignOut();
    mockAnalytics = MockAnalyticsService();

    // default: stream ไม่ emit อะไร (ป้องกัน side effect ระหว่าง test)
    when(() => mockRepository.authStateChanges)
        .thenAnswer((_) => const Stream.empty());

    // stub analytics — fire-and-forget, ไม่ต้อง verify
    when(() => mockAnalytics.setUserId(any())).thenAnswer((_) async {});
    when(
      () => mockAnalytics.logEvent(any(), parameters: any(named: 'parameters')),
    ).thenAnswer((_) async {});
    when(() => mockAnalytics.addBreadcrumb(any())).thenReturn(null);
  });

  test('initial state is AuthInitial', () {
    expect(buildBloc().state, const AuthInitial());
  });

  // ─── AuthStarted ────────────────────────────────────────────
  group('AuthStarted', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthAuthenticated] when stream emits a user',
      build: () {
        when(() => mockRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(tAuthUser));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const AuthAuthenticated(tAuthUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when stream emits null',
      build: () {
        when(() => mockRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(null));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const AuthUnauthenticated()],
    );
  });

  // ─── AuthSignInRequested ─────────────────────────────────────
  group('AuthSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => mockSignIn(any())).thenAnswer(
          (_) async => const Right(tAuthUser),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const AuthSignInRequested(email: tEmail, password: tPassword),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(tAuthUser),
      ],
      verify: (_) {
        verify(
          () => mockSignIn(
            const SignInParams(email: tEmail, password: tPassword),
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockSignIn(any())).thenAnswer(
          (_) async => const Left(AuthFailure('Incorrect email or password.')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const AuthSignInRequested(email: tEmail, password: tPassword),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('Incorrect email or password.'),
      ],
    );
  });

  // ─── AuthSignUpRequested ─────────────────────────────────────
  group('AuthSignUpRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => mockSignUp(any())).thenAnswer(
          (_) async => const Right(tAuthUser),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const AuthSignUpRequested(email: tEmail, password: tPassword),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(tAuthUser),
      ],
      verify: (_) {
        verify(
          () => mockSignUp(
            const SignUpParams(email: tEmail, password: tPassword),
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when email already in use',
      build: () {
        when(() => mockSignUp(any())).thenAnswer(
          (_) async => const Left(
            AuthFailure('An account already exists with this email.'),
          ),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(
        const AuthSignUpRequested(email: tEmail, password: tPassword),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError('An account already exists with this email.'),
      ],
    );
  });

  // ─── AuthGoogleSignInRequested ───────────────────────────────
  group('AuthGoogleSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => mockGoogleSignIn(const NoParams())).thenAnswer(
          (_) async => const Right(tAuthUser),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(tAuthUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when cancelled',
      build: () {
        when(() => mockGoogleSignIn(const NoParams())).thenAnswer(
          (_) async => const Left(AuthFailure('Google Sign-In cancelled.')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthGoogleSignInRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthError('Google Sign-In cancelled.'),
      ],
    );
  });

  // ─── AuthSignOutRequested ────────────────────────────────────
  group('AuthSignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] after sign out',
      build: () {
        when(() => mockSignOut(const NoParams())).thenAnswer(
          (_) async => const Right(unit),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const AuthSignOutRequested()),
      expect: () => [const AuthUnauthenticated()],
      verify: (_) {
        verify(() => mockSignOut(const NoParams())).called(1);
      },
    );
  });
}
