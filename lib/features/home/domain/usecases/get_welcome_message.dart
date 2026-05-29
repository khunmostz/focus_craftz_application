import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/core/usecases/usecase.dart';
import 'package:focus_craftz_application/features/home/domain/entities/welcome.dart';
import 'package:focus_craftz_application/features/home/domain/repositories/home_repository.dart';

class GetWelcomeMessage implements UseCase<Welcome, NoParams> {
  GetWelcomeMessage(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, Welcome>> call(NoParams params) {
    return _repository.getWelcomeMessage();
  }
}
