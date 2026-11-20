import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError("DefaultFirebaseOptions have not been configured for web.");
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError("DefaultFirebaseOptions are not supported for this platform.");
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAOV5c4Kk8HZDv0jAZpumWWdumqxZzL--c",
    appId: "1:935757516206:android:567397ca4593447ff0cc3f",
    messagingSenderId: "935757516206",
    projectId: "movies-app-team4",
    storageBucket: "movies-app-team4.firebasestorage.app",
  );
}