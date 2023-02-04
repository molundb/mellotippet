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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1vztbHt8jJXLymSlP2TyPVAmg8zBcYLY',
    appId: '1:997889272585:android:5f8072c75c1e25be4201d8',
    messagingSenderId: '997889272585',
    projectId: 'melodifestivalen-competition',
    databaseURL: 'https://melodifestivalen-competition-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'melodifestivalen-competition.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7TC-UHoICsDCm0E8thr9ArvLUliIzQ1s',
    appId: '1:997889272585:ios:09de893773df24e44201d8',
    messagingSenderId: '997889272585',
    projectId: 'melodifestivalen-competition',
    databaseURL: 'https://melodifestivalen-competition-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'melodifestivalen-competition.appspot.com',
    iosClientId: '997889272585-4hm7l232uul836hskpql7lstijoojs4k.apps.googleusercontent.com',
    iosBundleId: 'com.molundb.melodifestivalen-competition',
  );
}
