import 'package:focus_craftz_application/features/home/domain/entities/welcome.dart';

abstract class HomeLocalDataSource {
  Future<Welcome> getWelcomeMessage();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<Welcome> getWelcomeMessage() async {
    return const Welcome(message: 'Clean Architecture + BLoC is ready.');
  }
}
