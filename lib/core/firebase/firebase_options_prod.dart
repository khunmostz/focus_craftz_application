import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class FirebaseProdOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase options are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDoeFxaG5jZWYUyBWLwaNgwuGMqfkI3oyw',
    appId: '1:377254767225:android:23d05b7e09d9eb4bc302a8',
    messagingSenderId: '377254767225',
    projectId: 'focus-craftz-dev',
    storageBucket: 'focus-craftz-dev.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDba9jM8BwVgMQpwcrK6ratvqc7qhR8dlI',
    appId: '1:377254767225:ios:f61407e09c5e6cc0c302a8',
    messagingSenderId: '377254767225',
    projectId: 'focus-craftz-dev',
    storageBucket: 'focus-craftz-dev.firebasestorage.app',
    iosClientId: '377254767225-38hjplgm6do4isi52pbk23ncvuu7pa07.apps.googleusercontent.com',
    iosBundleId: 'com.khunmostz.focuscraftz',
  );

}