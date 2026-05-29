import 'package:dartz/dartz.dart';

import 'package:focus_craftz_application/core/error/failures.dart';
import 'package:focus_craftz_application/features/home/domain/entities/welcome.dart';

abstract class HomeRepository {
  Future<Either<Failure, Welcome>> getWelcomeMessage();
}
