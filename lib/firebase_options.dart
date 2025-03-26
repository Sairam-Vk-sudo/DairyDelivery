import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
  show defaultTargetPlatform, kIsWeb, TargetPlatform;

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Products"),
        BottomNavigationBarItem(icon: Icon(Icons.more_vert), label: "More"),
      ],
    );
  }
}
// File generated by FlutterFire CLI.
// ignore_for_file: type=lint



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
    piKey: '<FIREBASE_API_KEY>',
    appId: '<FIREBASE_APP_ID>',
    messagingSenderId: '<FIREBASE_MESSAGING_SENDER_ID>',
    projectId: '<FIREBASE_PROJECT_ID>',
    authDomain: '<FIREBASE_AUTH_DOMAIN>',
    storageBucket: '<FIREBASE_STORAGE_BUCKET>'
  );

  static const FirebaseOptions android = FirebaseOptions(
    piKey: '<FIREBASE_API_KEY>',
    appId: '<FIREBASE_APP_ID>',
    messagingSenderId: '<FIREBASE_MESSAGING_SENDER_ID>',
    projectId: '<FIREBASE_PROJECT_ID>',
    authDomain: '<FIREBASE_AUTH_DOMAIN>',
    storageBucket: '<FIREBASE_STORAGE_BUCKET>'
  );

  static const FirebaseOptions ios = FirebaseOptions(
    piKey: '<FIREBASE_API_KEY>',
    appId: '<FIREBASE_APP_ID>',
    messagingSenderId: '<FIREBASE_MESSAGING_SENDER_ID>',
    projectId: '<FIREBASE_PROJECT_ID>',
    authDomain: '<FIREBASE_AUTH_DOMAIN>',
    storageBucket: '<FIREBASE_STORAGE_BUCKET>'
  );

  static const FirebaseOptions macos = FirebaseOptions(
    piKey: '<FIREBASE_API_KEY>',
    appId: '<FIREBASE_APP_ID>',
    messagingSenderId: '<FIREBASE_MESSAGING_SENDER_ID>',
    projectId: '<FIREBASE_PROJECT_ID>',
    authDomain: '<FIREBASE_AUTH_DOMAIN>',
    storageBucket: '<FIREBASE_STORAGE_BUCKET>'
  );

  static const FirebaseOptions windows = FirebaseOptions(
    piKey: '<FIREBASE_API_KEY>',
    appId: '<FIREBASE_APP_ID>',
    messagingSenderId: '<FIREBASE_MESSAGING_SENDER_ID>',
    projectId: '<FIREBASE_PROJECT_ID>',
    authDomain: '<FIREBASE_AUTH_DOMAIN>',
    storageBucket: '<FIREBASE_STORAGE_BUCKET>'
  );

}
