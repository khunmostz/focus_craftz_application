import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/welcome.dart';
import '../repositories/home_repository.dart';

class GetWelcomeMessage implements UseCase<Welcome, NoParams> {
  GetWelcomeMessage(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, Welcome>> call(NoParams params) {
    return _repository.getWelcomeMessage();
  }
}
