import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:focus_craftz_application/features/home/domain/usecases/get_welcome_message.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetWelcomeMessage getWelcomeMessage})
    : _getWelcomeMessage = getWelcomeMessage,
      super(const HomeInitial()) {
    on<HomeStarted>(_onStarted);
  }

  final GetWelcomeMessage _getWelcomeMessage;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    final result = await _getWelcomeMessage(const NoParams());

    result.fold(
      (_) => emit(const HomeError('Unable to load data.')),
      (welcome) => emit(HomeLoaded(welcome.message)),
    );
  }
}
