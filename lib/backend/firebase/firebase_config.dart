import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCLc4nd9hTZiYoD4HWgF6A_6CYQYFpOTc0",
        authDomain: "max-taxi-admin-7n82h1.firebaseapp.com",
        projectId: "max-taxi-admin-7n82h1",
        storageBucket: "max-taxi-admin-7n82h1.appspot.com",
        messagingSenderId: "843578977445",
        appId: "1:843578977445:web:c1fb0f52caf163b4a4314c",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}
