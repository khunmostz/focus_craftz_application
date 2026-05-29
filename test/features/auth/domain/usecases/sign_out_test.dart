import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/domain/usecases/sign_out.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignOut useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignOut(mockRepository);
  });

  test('should sign out successfully', () async {
    when(() => mockRepository.signOut())
        .thenAnswer((_) async => const Right(unit));

    final result = await useCase(const NoParams());

    expect(result, const Right(unit));
    verify(() => mockRepository.signOut()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthFailure when sign out fails', () async {
    when(() => mockRepository.signOut()).thenAnswer(
      (_) async => const Left(AuthFailure('Failed to sign out.')),
    );

    final result = await useCase(const NoParams());

    expect(result, const Left(AuthFailure('Failed to sign out.')));
  });
}
