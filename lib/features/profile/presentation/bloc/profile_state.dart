part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  ProfileLoaded({required this.profile});
  final UserProfile profile;
}

final class ProfileError extends ProfileState {
  ProfileError({required this.message});
  final String message;
}
