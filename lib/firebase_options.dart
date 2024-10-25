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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCSDQktlpYETm6dE21y_Mde_0_yGI9OiR0',
    appId: '1:782865011392:web:7c57367f9a58b1ef6c9325',
    messagingSenderId: '782865011392',
    projectId: 'recipeapp-68384',
    authDomain: 'recipeapp-68384.firebaseapp.com',
    storageBucket: 'recipeapp-68384.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcRjim0oYFCNJp02oo-8w6K8lzQ2JqhN0',
    appId: '1:782865011392:android:25f961e80de475106c9325',
    messagingSenderId: '782865011392',
    projectId: 'recipeapp-68384',
    storageBucket: 'recipeapp-68384.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAx1Fmq_ZVzeLvcDJvlGBeWuL70XP2LfTM',
    appId: '1:782865011392:ios:24444d0113df43c56c9325',
    messagingSenderId: '782865011392',
    projectId: 'recipeapp-68384',
    storageBucket: 'recipeapp-68384.appspot.com',
    iosBundleId: 'com.example.recipeAppFlutter',
  );
}
