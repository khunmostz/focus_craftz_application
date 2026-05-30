import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/profile/domain/entities/user_profile.dart';
import 'package:focus_craftz_application/features/profile/domain/repositories/user_profile_repository.dart';

class CreateUserProfile
    implements UseCase<UserProfile, CreateUserProfileParams> {
  CreateUserProfile(this._repository);

  final UserProfileRepository _repository;

  @override
  Future<Either<Failure, UserProfile>> call(CreateUserProfileParams params) {
    return _repository.createUserProfile(
      uid: params.uid,
      email: params.email,
      displayName: params.displayName,
      photoUrl: params.photoUrl,
    );
  }
}

class CreateUserProfileParams {
  const CreateUserProfileParams({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
}
