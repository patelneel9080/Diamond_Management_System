import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
  );
}