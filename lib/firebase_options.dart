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
    apiKey: 'AIzaSyCNHEkDZjbU_VyFqmkugK1v4M2C5qVRxJA',
    appId: '1:862164183040:web:e08b339a523cff2ab550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    authDomain: 'diamond-management-322be.firebaseapp.com',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
    storageBucket: 'diamond-management-322be.firebasestorage.app',
    measurementId: 'G-GNLSTGQVV5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
    storageBucket: 'diamond-management-322be.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8V__kPNGWhhUYl8dVPSCM3t1nEmTTxk4',
    appId: '1:862164183040:ios:ea86fc0226d3dea9b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
    storageBucket: 'diamond-management-322be.firebasestorage.app',
    iosBundleId: 'com.example.gSheetApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8V__kPNGWhhUYl8dVPSCM3t1nEmTTxk4',
    appId: '1:862164183040:ios:ea86fc0226d3dea9b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
    storageBucket: 'diamond-management-322be.firebasestorage.app',
    iosBundleId: 'com.example.gSheetApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCNHEkDZjbU_VyFqmkugK1v4M2C5qVRxJA',
    appId: '1:862164183040:web:185ba4bd43bfa496b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    authDomain: 'diamond-management-322be.firebaseapp.com',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
    storageBucket: 'diamond-management-322be.firebasestorage.app',
    measurementId: 'G-K0GMJ21SWJ',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI',
    appId: '1:862164183040:android:062be2358927d813b550e5',
    messagingSenderId: '862164183040',
    projectId: 'diamond-management-322be',
    databaseURL: 'https://diamond-management-322be-default-rtdb.firebaseio.com',
  );
}