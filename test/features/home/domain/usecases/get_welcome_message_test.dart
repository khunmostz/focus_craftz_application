import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/home/domain/entities/welcome.dart';
import 'package:focus_craftz_application/features/home/domain/repositories/home_repository.dart';
import 'package:focus_craftz_application/features/home/domain/usecases/get_welcome_message.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late GetWelcomeMessage useCase;
  late MockHomeRepository mockHomeRepository;

  const welcome = Welcome(message: 'clean arch use case');

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetWelcomeMessage(mockHomeRepository);
  });

  test('should get welcome message from repository', () async {
    when(
      () => mockHomeRepository.getWelcomeMessage(),
    ).thenAnswer((_) async => const Right(welcome));

    final result = await useCase(const NoParams());

    expect(result, equals(const Right(welcome)));
    verify(() => mockHomeRepository.getWelcomeMessage()).called(1);
    verifyNoMoreInteractions(mockHomeRepository);
  });
}
