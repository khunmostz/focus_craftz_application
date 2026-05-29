import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInWithEmailPassword useCase;
  late MockAuthRepository mockRepository;

  const tAuthUser = AuthUser(uid: 'uid-1', email: 'test@test.com');
  const tParams = SignInParams(email: 'test@test.com', password: 'password123');

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInWithEmailPassword(mockRepository);
  });

  test('should sign in and return AuthUser on success', () async {
    when(
      () => mockRepository.signInWithEmailAndPassword(
        email: tParams.email,
        password: tParams.password,
      ),
    ).thenAnswer((_) async => const Right(tAuthUser));

    final result = await useCase(tParams);

    expect(result, const Right(tAuthUser));
    verify(
      () => mockRepository.signInWithEmailAndPassword(
        email: tParams.email,
        password: tParams.password,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthFailure when sign in fails', () async {
    when(
      () => mockRepository.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(AuthFailure('Incorrect email or password.')));

    final result = await useCase(tParams);

    expect(result, const Left(AuthFailure('Incorrect email or password.')));
  });
}
