part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileLoadRequested extends ProfileEvent {
  ProfileLoadRequested({required this.uid});
  final String uid;
}
