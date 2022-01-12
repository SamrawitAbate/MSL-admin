import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'activatePage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: email),
          TextField(
            controller: password,
            obscureText: true,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                  if (userCredential.user != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>const ActivatePage()));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    setState(() {
                      message = 'No user found for that email.';
                    });
                  } else if (e.code == 'wrong-password') {
                    setState(() {
                      message = 'Wrong password provided for that user.';
                    });
                  }
                } catch (e) {
                  setState(() {
                    message = e.toString();
                  });
                }
              },
              child: const Text('Log in')),
          Text(message)
        ],
      ),
    );
  }
}
