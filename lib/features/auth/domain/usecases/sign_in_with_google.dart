import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle extends UseCase<AuthUser, NoParams> {
  SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser>> call(NoParams params) =>
      _repository.signInWithGoogle();
}
