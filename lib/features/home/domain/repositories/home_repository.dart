import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/welcome.dart';

abstract class HomeRepository {
  Future<Either<Failure, Welcome>> getWelcomeMessage();
}
