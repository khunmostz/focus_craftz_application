import 'package:flutter_test/flutter_test.dart';
import 'package:focus_craftz_application/features/home/data/datasources/home_local_data_source.dart';
import 'package:focus_craftz_application/features/home/domain/entities/welcome.dart';

void main() {
  late HomeLocalDataSource dataSource;

  setUp(() {
    dataSource = HomeLocalDataSourceImpl();
  });

  test('should return static welcome message', () async {
    final result = await dataSource.getWelcomeMessage();

    expect(
      result,
      equals(const Welcome(message: 'Clean Architecture + BLoC is ready.')),
    );
  });
}
