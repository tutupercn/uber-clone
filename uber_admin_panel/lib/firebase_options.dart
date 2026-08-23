import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Kocaeli TAG yönetim paneli şu anda yalnızca web için yapılandırıldı.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyArl1ADeWM65Hlv5kNtLHzX99tdFSY-PgM',
    appId: '1:563100971019:web:8e4b991f0a0e990ee1d70e',
    messagingSenderId: '563100971019',
    projectId: 'kocaeli-tag',
    authDomain: 'kocaeli-tag.firebaseapp.com',
    databaseURL: 'https://kocaeli-tag-default-rtdb.firebaseio.com',
    storageBucket: 'kocaeli-tag.firebasestorage.app',
    measurementId: 'G-H4V1TNF4QT',
  );
}
