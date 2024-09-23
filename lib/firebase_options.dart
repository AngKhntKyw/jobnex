// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDYbiR4rHowX5nqVv8MY5SOkZmr2OL3Svo',
    appId: '1:561074479638:web:2ccfea337644c9d2b24b37',
    messagingSenderId: '561074479638',
    projectId: 'together-3',
    authDomain: 'together-3.firebaseapp.com',
    storageBucket: 'together-3.appspot.com',
    measurementId: 'G-VP67QXFNT7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtSf0KhivECgE2qsFkYI7PU7_elFUKMQY',
    appId: '1:561074479638:android:d59a6cb6ffc3b3deb24b37',
    messagingSenderId: '561074479638',
    projectId: 'together-3',
    storageBucket: 'together-3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZpo4rgwF5P_hByDZlL0AVmDNdienqIOk',
    appId: '1:561074479638:ios:7c3cd1623ededa04b24b37',
    messagingSenderId: '561074479638',
    projectId: 'together-3',
    storageBucket: 'together-3.appspot.com',
    iosBundleId: 'com.example.jobnex',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZpo4rgwF5P_hByDZlL0AVmDNdienqIOk',
    appId: '1:561074479638:ios:4bd473be945f0e4cb24b37',
    messagingSenderId: '561074479638',
    projectId: 'together-3',
    storageBucket: 'together-3.appspot.com',
    iosBundleId: 'com.example.freezedExample',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDYbiR4rHowX5nqVv8MY5SOkZmr2OL3Svo',
    appId: '1:561074479638:web:d1941ce1d5fa131cb24b37',
    messagingSenderId: '561074479638',
    projectId: 'together-3',
    authDomain: 'together-3.firebaseapp.com',
    storageBucket: 'together-3.appspot.com',
    measurementId: 'G-NXY71CEX89',
  );

}