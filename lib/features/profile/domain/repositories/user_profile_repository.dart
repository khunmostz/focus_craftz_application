import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/profile/domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile(String uid);
  Future<Either<Failure, UserProfile>> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  });
}
