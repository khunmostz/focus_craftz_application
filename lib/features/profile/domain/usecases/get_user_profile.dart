import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/profile/domain/entities/user_profile.dart';
import 'package:focus_craftz_application/features/profile/domain/repositories/user_profile_repository.dart';

class GetUserProfile implements UseCase<UserProfile, GetUserProfileParams> {
  GetUserProfile(this._repository);

  final UserProfileRepository _repository;

  @override
  Future<Either<Failure, UserProfile>> call(GetUserProfileParams params) {
    return _repository.getUserProfile(params.uid);
  }
}

class GetUserProfileParams {
  const GetUserProfileParams({required this.uid});
  final String uid;
}
