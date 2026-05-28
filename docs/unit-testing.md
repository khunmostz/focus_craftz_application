# Unit Testing Guide (Clean Architecture + BLoC)

This project uses unit tests to validate each layer independently.

## What to test in each layer

- Data source: return values and thrown errors.
- Repository: map success/error from data source to domain result (`Either`).
- Use case: call repository correctly.
- BLoC: emitted states for each event and result path.

## Example tests in this project

- Data source example: `test/features/home/data/datasources/home_local_data_source_test.dart`
- Repository example: `test/features/home/data/repositories/home_repository_impl_test.dart`
- Use case example: `test/features/home/domain/usecases/get_welcome_message_test.dart`
- BLoC example: `test/features/home/presentation/bloc/home_bloc_test.dart`

## Run tests

Run all tests:

```bash
flutter test
```

Run only Home feature tests:

```bash
flutter test test/features/home
```

Run only BLoC test file:

```bash
flutter test test/features/home/presentation/bloc/home_bloc_test.dart
```

## Pattern used (AAA)

Use the Arrange, Act, Assert flow in every test.

```dart
test('should return welcome when datasource succeeds', () async {
  // Arrange
  when(() => mockLocalDataSource.getWelcomeMessage())
      .thenAnswer((_) async => welcome);

  // Act
  final result = await repository.getWelcomeMessage();

  // Assert
  expect(result, equals(const Right(welcome)));
});
```

## Mocking dependencies

- `mocktail` is used to mock interfaces/classes.
- `bloc_test` is used to assert emitted BLoC states.
- Mock only external dependencies of the unit under test.

## Checklist for adding a new feature

1. Add tests in matching layer folders under `test/features/<feature_name>/...`.
2. Add repository tests for success and failure paths.
3. Add use case tests to verify repository interaction.
4. Add BLoC tests for expected state sequences.
5. Keep unit tests focused and independent from Firebase/network/UI.
