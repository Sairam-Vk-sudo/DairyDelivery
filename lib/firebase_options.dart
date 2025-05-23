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
    apiKey: 'AIzaSyDUzLmMcbWCq0kZt-SHjtbD3Hqmxf3zRKY',
    appId: '1:775815644930:web:77a41d94f45017ea82241b',
    messagingSenderId: '775815644930',
    projectId: 'dairydelivery-99f70',
    authDomain: 'dairydelivery-99f70.firebaseapp.com',
    storageBucket: 'dairydelivery-99f70.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAD9E3Db6jXGnDbCAVfX6Y6LLnI8t3fVGk',
    appId: '1:775815644930:android:e7d0a3b16af0f6de82241b',
    messagingSenderId: '775815644930',
    projectId: 'dairydelivery-99f70',
    storageBucket: 'dairydelivery-99f70.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZx7o2qdbJI9LZUKShhP8GubaXz8cbW1E',
    appId: '1:775815644930:ios:4236f43e68a7875f82241b',
    messagingSenderId: '775815644930',
    projectId: 'dairydelivery-99f70',
    storageBucket: 'dairydelivery-99f70.firebasestorage.app',
    iosBundleId: 'com.example.dairyDelivery',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZx7o2qdbJI9LZUKShhP8GubaXz8cbW1E',
    appId: '1:775815644930:ios:4236f43e68a7875f82241b',
    messagingSenderId: '775815644930',
    projectId: 'dairydelivery-99f70',
    storageBucket: 'dairydelivery-99f70.firebasestorage.app',
    iosBundleId: 'com.example.dairyDelivery',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUzLmMcbWCq0kZt-SHjtbD3Hqmxf3zRKY',
    appId: '1:775815644930:web:261cd4311589f9f782241b',
    messagingSenderId: '775815644930',
    projectId: 'dairydelivery-99f70',
    authDomain: 'dairydelivery-99f70.firebaseapp.com',
    storageBucket: 'dairydelivery-99f70.firebasestorage.app',
  );

}
