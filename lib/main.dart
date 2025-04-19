import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDqdeqRAk94DV-_687H2spwQmI-W1nDjrE",
        authDomain: "homework4-6a4b7.firebaseapp.com",
        projectId: "homework4-6a4b7",
        storageBucket: "homework4-6a4b7.firebasestorage.app",
        messagingSenderId: "984366763011",
        appId: "1:984366763011:web:9e68bc868f891dacbed236",
      ),
    );
  } else {
 
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Board App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
