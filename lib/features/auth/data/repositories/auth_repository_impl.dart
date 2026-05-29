import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/exceptions.dart';
import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';
import 'package:focus_craftz_application/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Stream<AuthUser?> get authStateChanges => _dataSource.authStateChanges;

  @override
  AuthUser? get currentUser => _dataSource.currentUser;

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUser>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    try {
      final user = await _dataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(AuthFailure());
    }
  }
}
