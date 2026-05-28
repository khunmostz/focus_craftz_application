import 'package:firebase_core/firebase_core.dart';

import 'app_flavor.dart';
import 'firebase_options_dev.dart';
import 'firebase_options_prod.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (AppFlavorConfig.current) {
      case AppFlavor.prod:
        return FirebaseProdOptions.currentPlatform;
      case AppFlavor.dev:
        return FirebaseDevOptions.currentPlatform;
    }
  }
}
