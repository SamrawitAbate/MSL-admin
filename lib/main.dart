import 'package:admin/pages/login.dart';
import 'package:admin/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAliJ1HpRz75DDVo29iWp0BePOIkqvwjxo",
        authDomain: "car-service-c12ce.firebaseapp.com",
        projectId: "car-service-c12ce",
        storageBucket: "car-service-c12ce.appspot.com",
        messagingSenderId: "801355599085",
        appId: "1:801355599085:web:7c5f7659a8ede553ab50e4"),
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Maintenance service locator',
    theme: ThemeData(brightness: Brightness.light, fontFamily: 'Numans'),
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
          return Center(
              child: Row(
            children: [
              const Icon(Icons.error),
              Text(snapshot.error.toString())
            ],
          ));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const Login();
        }
        return const Loading();
      },
    );
  }
}
