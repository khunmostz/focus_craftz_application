import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/auth/domain/entities/auth_user.dart';
import 'package:focus_craftz_application/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailPassword extends UseCase<AuthUser, SignInParams> {
  SignInWithEmailPassword(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser>> call(SignInParams params) =>
      _repository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
