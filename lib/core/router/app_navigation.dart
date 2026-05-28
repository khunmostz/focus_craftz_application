import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

extension AppNavigation on BuildContext {
  void goHome() => goNamed(AppRoutes.homeName);

  void openDetails() => pushNamed(AppRoutes.detailsName);

  void back() {
    if (canPop()) {
      pop();
    }
  }
}
