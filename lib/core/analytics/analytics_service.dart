abstract class AnalyticsService {
  Future<void> setUserId(String? userId);
  Future<void> logScreenView(String screenName);
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> recordError(Object error, StackTrace? stack, {bool fatal = false});
  void addBreadcrumb(String message);
}
