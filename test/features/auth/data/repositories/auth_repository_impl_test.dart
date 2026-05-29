import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/error/exceptions.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:focus_craftz_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  const tAuthUser = AuthUser(uid: 'uid-1', email: 'test@test.com');
  const tEmail = 'test@test.com';
  const tPassword = 'password123';

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('signInWithEmailAndPassword', () {
    test('should return AuthUser on success', () async {
      when(
        () => mockDataSource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tAuthUser);

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Right(tAuthUser));
    });

    test('should return AuthFailure when AuthException is thrown', () async {
      when(
        () => mockDataSource.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Incorrect email or password.'));

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(AuthFailure('Incorrect email or password.')));
    });

    test('should return AuthFailure on unexpected error', () async {
      when(
        () => mockDataSource.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('unexpected'));

      final result = await repository.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Left(AuthFailure()));
    });
  });

  group('createUserWithEmailAndPassword', () {
    test('should return AuthUser on success', () async {
      when(
        () => mockDataSource.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tAuthUser);

      final result = await repository.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result, const Right(tAuthUser));
    });

    test('should return AuthFailure when email already in use', () async {
      when(
        () => mockDataSource.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const AuthException('An account already exists with this email.'),
      );

      final result = await repository.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(
        result,
        const Left(AuthFailure('An account already exists with this email.')),
      );
    });
  });

  group('signInWithGoogle', () {
    test('should return AuthUser on success', () async {
      when(() => mockDataSource.signInWithGoogle())
          .thenAnswer((_) async => tAuthUser);

      final result = await repository.signInWithGoogle();

      expect(result, const Right(tAuthUser));
    });

    test('should return AuthFailure when cancelled', () async {
      when(() => mockDataSource.signInWithGoogle())
          .thenThrow(const AuthException('Google Sign-In cancelled.'));

      final result = await repository.signInWithGoogle();

      expect(result, const Left(AuthFailure('Google Sign-In cancelled.')));
    });
  });

  group('signOut', () {
    test('should return unit on success', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right(unit));
    });

    test('should return AuthFailure when sign out fails', () async {
      when(() => mockDataSource.signOut())
          .thenThrow(const AuthException('Failed to sign out.'));

      final result = await repository.signOut();

      expect(result, const Left(AuthFailure('Failed to sign out.')));
    });
  });

  group('authStateChanges', () {
    test('should return stream from data source', () {
      final tStream = Stream<AuthUser?>.value(tAuthUser);
      when(() => mockDataSource.authStateChanges).thenAnswer((_) => tStream);

      expect(repository.authStateChanges, tStream);
    });
  });

  group('currentUser', () {
    test('should return user from data source when logged in', () {
      when(() => mockDataSource.currentUser).thenReturn(tAuthUser);

      expect(repository.currentUser, tAuthUser);
    });

    test('should return null from data source when logged out', () {
      when(() => mockDataSource.currentUser).thenReturn(null);

      expect(repository.currentUser, isNull);
    });
  });
}
