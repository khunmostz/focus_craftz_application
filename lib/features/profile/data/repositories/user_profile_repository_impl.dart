import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/exceptions.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/profile/data/datasources/user_profile_remote_data_source.dart';
import 'package:focus_craftz_application/features/profile/domain/entities/user_profile.dart';
import 'package:focus_craftz_application/features/profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._dataSource);

  final UserProfileRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(String uid) async {
    try {
      final model = await _dataSource.getUserProfile(uid);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final model = await _dataSource.createUserProfile(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
