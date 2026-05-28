import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/welcome.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._localDataSource);

  final HomeLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, Welcome>> getWelcomeMessage() async {
    try {
      final welcome = await _localDataSource.getWelcomeMessage();
      return Right(welcome);
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
