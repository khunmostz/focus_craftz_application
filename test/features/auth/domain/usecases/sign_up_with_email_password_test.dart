import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_up_with_email_password.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUpWithEmailPassword useCase;
  late MockAuthRepository mockRepository;

  const tAuthUser = AuthUser(uid: 'uid-1', email: 'new@test.com');
  const tParams = SignUpParams(email: 'new@test.com', password: 'password123');

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpWithEmailPassword(mockRepository);
  });

  test('should create account and return AuthUser on success', () async {
    when(
      () => mockRepository.createUserWithEmailAndPassword(
        email: tParams.email,
        password: tParams.password,
      ),
    ).thenAnswer((_) async => const Right(tAuthUser));

    final result = await useCase(tParams);

    expect(result, const Right(tAuthUser));
    verify(
      () => mockRepository.createUserWithEmailAndPassword(
        email: tParams.email,
        password: tParams.password,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthFailure when email already in use', () async {
    when(
      () => mockRepository.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => const Left(AuthFailure('An account already exists with this email.')),
    );

    final result = await useCase(tParams);

    expect(result, const Left(AuthFailure('An account already exists with this email.')));
  });
}
