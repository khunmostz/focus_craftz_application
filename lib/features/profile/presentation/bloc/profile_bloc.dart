import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:focus_craftz_application/core/analytics/analytics_service.dart';
import 'package:focus_craftz_application/features/profile/domain/entities/user_profile.dart';
import 'package:focus_craftz_application/features/profile/domain/usecases/get_user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.getUserProfile,
    required AnalyticsService analyticsService,
  })  : _analyticsService = analyticsService,
        super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
  }

  final GetUserProfile getUserProfile;
  final AnalyticsService _analyticsService;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getUserProfile(GetUserProfileParams(uid: event.uid));
    result.fold(
      (failure) {
        _analyticsService.addBreadcrumb(
          'profile_load_failed: ${failure.message}',
        );
        emit(ProfileError(message: failure.message));
      },
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }
}
