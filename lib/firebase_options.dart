// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAq0TJiv8fJNfVwePsJwW5Svn8lItQFTcs',
    appId: '1:328500609429:web:15001dba4f1bca9918369c',
    messagingSenderId: '328500609429',
    projectId: 'dentex-f4614',
    authDomain: 'dentex-f4614.firebaseapp.com',
    storageBucket: 'dentex-f4614.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_npzSJc7eakdNFolOQ_zZOh7VsaEADZ8',
    appId: '1:328500609429:android:7b5389636b52681018369c',
    messagingSenderId: '328500609429',
    projectId: 'dentex-f4614',
    storageBucket: 'dentex-f4614.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoA07iIHE7Niom4okqBZEZqWuKyEBwc7g',
    appId: '1:328500609429:ios:80e1c6ea0cb8d4f218369c',
    messagingSenderId: '328500609429',
    projectId: 'dentex-f4614',
    storageBucket: 'dentex-f4614.appspot.com',
    iosClientId: '328500609429-7urmb8g9g53habl61j3a9k3rm9hfl9qg.apps.googleusercontent.com',
    iosBundleId: 'com.shawket.dentex',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoA07iIHE7Niom4okqBZEZqWuKyEBwc7g',
    appId: '1:328500609429:ios:80e1c6ea0cb8d4f218369c',
    messagingSenderId: '328500609429',
    projectId: 'dentex-f4614',
    storageBucket: 'dentex-f4614.appspot.com',
    iosClientId: '328500609429-7urmb8g9g53habl61j3a9k3rm9hfl9qg.apps.googleusercontent.com',
    iosBundleId: 'com.shawket.dentex',
  );
}
