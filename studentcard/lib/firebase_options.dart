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
    apiKey: 'AIzaSyDiU0cwq9CdFbSbtxUR2yOg0wnHlJTacnY',
    appId: '1:420316186925:web:150b9a13a7141da7d0aba4',
    messagingSenderId: '420316186925',
    projectId: 'e-studentcardfyp',
    authDomain: 'e-studentcardfyp.firebaseapp.com',
    storageBucket: 'e-studentcardfyp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvpbCLWruVVzM2SWgdvbvy8IJCnfx9mNk',
    appId: '1:420316186925:android:32074f12c4636401d0aba4',
    messagingSenderId: '420316186925',
    projectId: 'e-studentcardfyp',
    storageBucket: 'e-studentcardfyp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAboXE6_r5aevOEdm1ixJPFSPVjnK-ZsBI',
    appId: '1:420316186925:ios:9cf11057720369fad0aba4',
    messagingSenderId: '420316186925',
    projectId: 'e-studentcardfyp',
    storageBucket: 'e-studentcardfyp.appspot.com',
    iosBundleId: 'com.example.studentcard',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAboXE6_r5aevOEdm1ixJPFSPVjnK-ZsBI',
    appId: '1:420316186925:ios:9cf11057720369fad0aba4',
    messagingSenderId: '420316186925',
    projectId: 'e-studentcardfyp',
    storageBucket: 'e-studentcardfyp.appspot.com',
    iosBundleId: 'com.example.studentcard',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDiU0cwq9CdFbSbtxUR2yOg0wnHlJTacnY',
    appId: '1:420316186925:web:69a7ce4f4b6de5e9d0aba4',
    messagingSenderId: '420316186925',
    projectId: 'e-studentcardfyp',
    authDomain: 'e-studentcardfyp.firebaseapp.com',
    storageBucket: 'e-studentcardfyp.appspot.com',
  );

}