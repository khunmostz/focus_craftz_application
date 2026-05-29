import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInWithGoogle useCase;
  late MockAuthRepository mockRepository;

  const tAuthUser = AuthUser(
    uid: 'google-uid-1',
    email: 'google@gmail.com',
    displayName: 'Google User',
    photoUrl: 'https://example.com/photo.jpg',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInWithGoogle(mockRepository);
  });

  test('should sign in with Google and return AuthUser on success', () async {
    when(() => mockRepository.signInWithGoogle())
        .thenAnswer((_) async => const Right(tAuthUser));

    final result = await useCase(const NoParams());

    expect(result, const Right(tAuthUser));
    verify(() => mockRepository.signInWithGoogle()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthFailure when Google Sign-In is cancelled', () async {
    when(() => mockRepository.signInWithGoogle()).thenAnswer(
      (_) async => const Left(AuthFailure('Google Sign-In cancelled.')),
    );

    final result = await useCase(const NoParams());

    expect(result, const Left(AuthFailure('Google Sign-In cancelled.')));
  });

  test('should return AuthFailure when Google Sign-In fails', () async {
    when(() => mockRepository.signInWithGoogle()).thenAnswer(
      (_) async => const Left(AuthFailure('Google Sign-In failed. Please try again.')),
    );

    final result = await useCase(const NoParams());

    expect(result, const Left(AuthFailure('Google Sign-In failed. Please try again.')));
  });
}
