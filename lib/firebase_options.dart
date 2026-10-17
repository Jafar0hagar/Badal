import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyExampleKeyForAndroidFirestoreOnly',
    appId: '1:144305708744:android:2c8954e101314d50aa688d',
    messagingSenderId: '144305708744',
    projectId: 'ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8',
    storageBucket: 'ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyExampleKeyForIOSFirestoreOnly',
    appId: '1:144305708744:ios:2c8954e101314d50aa688d',
    messagingSenderId: '144305708744',
    projectId: 'ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8',
    storageBucket: 'ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8.appspot.com',
    iosBundleId: 'com.badal.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyExampleKeyForWebFirestoreOnly',
    appId: '1:144305708744:web:2c8954e101314d50aa688d',
    messagingSenderId: '144305708744',
    projectId: 'ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8',
    storageBucket: 'ai-studio-2c8954e1-0131-4d50-aa68-8d6bf61d2bc8.appspot.com',
  );
}
