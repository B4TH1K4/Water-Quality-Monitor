import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'screens/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'navigation_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyBNYTz2mGKsqHeKE__q_zFTGFzOzLhSQnw",
    authDomain: "water-quality-monitoring-4e15f.firebaseapp.com",
    databaseURL: "https://water-quality-monitoring-4e15f-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "water-quality-monitoring-4e15f",
    storageBucket: "water-quality-monitoring-4e15f.firebasestorage.app",
    messagingSenderId: "847124439591",
    appId: "1:847124439591:web:89bd6b39facde042516402",
    measurementId: "G-1M0R0EJEDZ"));
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavigationMenu(), // Home screen of your app
    );
  }
}
