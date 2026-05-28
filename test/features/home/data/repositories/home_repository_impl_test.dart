import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/home/data/datasources/home_local_data_source.dart';
import 'package:focus_craftz_application/features/home/data/repositories/home_repository_impl.dart';
import 'package:focus_craftz_application/features/home/domain/entities/welcome.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeLocalDataSource extends Mock implements HomeLocalDataSource {}

void main() {
  late HomeRepositoryImpl repository;
  late MockHomeLocalDataSource mockLocalDataSource;

  const welcome = Welcome(message: 'unit test message');

  setUp(() {
    mockLocalDataSource = MockHomeLocalDataSource();
    repository = HomeRepositoryImpl(mockLocalDataSource);
  });

  test('should return welcome when datasource succeeds', () async {
    when(
      () => mockLocalDataSource.getWelcomeMessage(),
    ).thenAnswer((_) async => welcome);

    final result = await repository.getWelcomeMessage();

    expect(result, equals(const Right(welcome)));
    verify(() => mockLocalDataSource.getWelcomeMessage()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });

  test('should return UnknownFailure when datasource throws', () async {
    when(
      () => mockLocalDataSource.getWelcomeMessage(),
    ).thenThrow(Exception('boom'));

    final result = await repository.getWelcomeMessage();

    expect(result, equals(const Left(UnknownFailure())));
    verify(() => mockLocalDataSource.getWelcomeMessage()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });
}
