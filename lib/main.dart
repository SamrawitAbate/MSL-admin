import 'package:admin/pages/dashBord.dart';
import 'package:admin/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDTuMFxPAdVxK8xjsrm3h9q1vleWR8I5tk",
        authDomain: "maintenance-service-locator.firebaseapp.com",
        projectId: "maintenance-service-locator",
        storageBucket: "maintenance-service-locator.appspot.com",
        messagingSenderId: "451295862796",
        appId: "1:451295862796:web:02ab98e4a5917ff9814e29"),
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Maintenance service locator',
    theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Numans'),
    home: App(),
  ));
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Center(child: Icon(Icons.error));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (FirebaseAuth.instance.currentUser != null) {
            // 'User is currently signed out!'
            return const Login();
          } else {
            //'User is signed in!'
            return const DashBord();
          }
        }

        return const Center(child: Icon(Icons.circle_outlined));
      },
    );
  }
}
