import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  AuthUser? get currentUser;

  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> signInWithGoogle();

  Future<Either<Failure, Unit>> signOut();
}
