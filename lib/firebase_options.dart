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
    apiKey: 'AIzaSyB1dF_Z86H42Dbal5MnpGbSYxJpSqz2XoY',
    appId: '1:778721033498:web:d95b9866f0f7af0ea300a3',
    messagingSenderId: '778721033498',
    projectId: 'athr-chat-app',
    authDomain: 'athr-chat-app.firebaseapp.com',
    storageBucket: 'athr-chat-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8A9SJpjdwVkUYZQaRNPQIU2nqgHzYgSg',
    appId: '1:778721033498:android:abbf54b9fa7651b2a300a3',
    messagingSenderId: '778721033498',
    projectId: 'athr-chat-app',
    storageBucket: 'athr-chat-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfnrwLRkXQIxeI85HW6JF9Mqpyglb9WGo',
    appId: '1:778721033498:ios:be6e32ecf9dfaa0aa300a3',
    messagingSenderId: '778721033498',
    projectId: 'athr-chat-app',
    storageBucket: 'athr-chat-app.firebasestorage.app',
    iosBundleId: 'com.example.chatApp',
  );
}
