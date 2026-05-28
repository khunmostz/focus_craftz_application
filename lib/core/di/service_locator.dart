import 'package:get_it/get_it.dart';

import '../../features/home/data/datasources/home_local_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_welcome_message.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';

final locator = GetIt.instance;

Future<void> initServiceLocator() async {
  locator.registerFactory(() => HomeBloc(getWelcomeMessage: locator()));

  locator.registerLazySingleton(() => GetWelcomeMessage(locator()));

  locator.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(locator()));

  locator.registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new);
}
