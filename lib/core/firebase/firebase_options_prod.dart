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
    apiKey: 'AIzaSyBlbfMBv4If7koEGWG06x5IbrhYl4WWghw',
    appId: '1:589350790558:android:767ba8e558087799e9228f',
    messagingSenderId: '589350790558',
    projectId: 'focus-craftz-prod',
    storageBucket: 'focus-craftz-prod.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwQnmbxNys3Ly6pXJPMjs0AQR6b3YA-6Q',
    appId: '1:589350790558:ios:eab089832a955bf6e9228f',
    messagingSenderId: '589350790558',
    projectId: 'focus-craftz-prod',
    storageBucket: 'focus-craftz-prod.firebasestorage.app',
    iosClientId: '589350790558-kn029q8ecqdq68oaoh8sdjoh9a7t77si.apps.googleusercontent.com',
    iosBundleId: 'com.khunmostz.focuscraftz',
  );

}