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
    apiKey: 'AIzaSyAmCtfWCyvFz6XyDHoakW8OMGZ1x3Uf9lU',
    appId: '1:265918329853:web:ef541e64ad583eab995f94',
    messagingSenderId: '265918329853',
    projectId: 'onlinemart-app',
    authDomain: 'onlinemart-app.firebaseapp.com',
    storageBucket: 'onlinemart-app.appspot.com',
    measurementId: 'G-197HJWENNH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFnBJICF2CG__hWx4zZbIUx8yoXBV7Gf4',
    appId: '1:265918329853:android:e87f852b5e6b3c68995f94',
    messagingSenderId: '265918329853',
    projectId: 'onlinemart-app',
    storageBucket: 'onlinemart-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDf_zu8SvHtqhjNlch0Mj6vPnHfKJAp4Nw',
    appId: '1:265918329853:ios:1202b2f8bb20f40c995f94',
    messagingSenderId: '265918329853',
    projectId: 'onlinemart-app',
    storageBucket: 'onlinemart-app.appspot.com',
    iosBundleId: 'com.example.emart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDf_zu8SvHtqhjNlch0Mj6vPnHfKJAp4Nw',
    appId: '1:265918329853:ios:1202b2f8bb20f40c995f94',
    messagingSenderId: '265918329853',
    projectId: 'onlinemart-app',
    storageBucket: 'onlinemart-app.appspot.com',
    iosBundleId: 'com.example.emart',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAmCtfWCyvFz6XyDHoakW8OMGZ1x3Uf9lU',
    appId: '1:265918329853:web:46f2caeb901b605b995f94',
    messagingSenderId: '265918329853',
    projectId: 'onlinemart-app',
    authDomain: 'onlinemart-app.firebaseapp.com',
    storageBucket: 'onlinemart-app.appspot.com',
    measurementId: 'G-F33NYZEQY1',
  );

}