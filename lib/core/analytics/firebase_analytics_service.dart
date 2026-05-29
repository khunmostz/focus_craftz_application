import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService({
    required FirebaseAnalytics analytics,
    required FirebaseCrashlytics crashlytics,
  })  : _analytics = analytics,
        _crashlytics = crashlytics;

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> setUserId(String? userId) async {
    await Future.wait([
      _analytics.setUserId(id: userId),
      _crashlytics.setUserIdentifier(userId ?? ''),
    ]);
  }

  @override
  Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) =>
      _analytics.logEvent(name: name, parameters: parameters);

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) =>
      _crashlytics.recordError(error, stack, fatal: fatal);

  @override
  void addBreadcrumb(String message) => _crashlytics.log(message);
}
