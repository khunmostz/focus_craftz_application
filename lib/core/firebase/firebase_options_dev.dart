import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class FirebaseDevOptions {
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
    appId: '1:377254767225:android:0274cb0a6c52a077c302a8',
    messagingSenderId: '377254767225',
    projectId: 'focus-craftz-dev',
    storageBucket: 'focus-craftz-dev.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDba9jM8BwVgMQpwcrK6ratvqc7qhR8dlI',
    appId: '1:377254767225:ios:d20a34428c83d9c6c302a8',
    messagingSenderId: '377254767225',
    projectId: 'focus-craftz-dev',
    storageBucket: 'focus-craftz-dev.firebasestorage.app',
    iosClientId: '377254767225-qlaekpp1l4jsh26p8kh4kunf2thu5cnp.apps.googleusercontent.com',
    iosBundleId: 'com.khunmostz.focuscraftz.dev',
  );

}