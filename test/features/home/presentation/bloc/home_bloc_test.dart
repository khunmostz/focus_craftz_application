import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/home/domain/entities/welcome.dart';
import 'package:focus_craftz_application/features/home/domain/usecases/get_welcome_message.dart';
import 'package:focus_craftz_application/features/home/presentation/bloc/home_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWelcomeMessage extends Mock implements GetWelcomeMessage {}

void main() {
  late MockGetWelcomeMessage mockGetWelcomeMessage;

  setUp(() {
    mockGetWelcomeMessage = MockGetWelcomeMessage();
  });

  test('initial state should be HomeInitial', () {
    final bloc = HomeBloc(getWelcomeMessage: mockGetWelcomeMessage);

    expect(bloc.state, equals(const HomeInitial()));

    bloc.close();
  });

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeLoaded] when use case succeeds',
    build: () {
      when(() => mockGetWelcomeMessage(const NoParams())).thenAnswer(
        (_) async => const Right(Welcome(message: 'hello from bloc test')),
      );

      return HomeBloc(getWelcomeMessage: mockGetWelcomeMessage);
    },
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const [HomeLoading(), HomeLoaded('hello from bloc test')],
    verify: (_) {
      verify(() => mockGetWelcomeMessage(const NoParams())).called(1);
      verifyNoMoreInteractions(mockGetWelcomeMessage);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits [HomeLoading, HomeError] when use case fails',
    build: () {
      when(
        () => mockGetWelcomeMessage(const NoParams()),
      ).thenAnswer((_) async => const Left(UnknownFailure()));

      return HomeBloc(getWelcomeMessage: mockGetWelcomeMessage);
    },
    act: (bloc) => bloc.add(const HomeStarted()),
    expect: () => const [HomeLoading(), HomeError('Unable to load data.')],
    verify: (_) {
      verify(() => mockGetWelcomeMessage(const NoParams())).called(1);
      verifyNoMoreInteractions(mockGetWelcomeMessage);
    },
  );
}
