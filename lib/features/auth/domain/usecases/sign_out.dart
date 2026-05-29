import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';

class SignOut extends UseCase<Unit, NoParams> {
  SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.signOut();
}
