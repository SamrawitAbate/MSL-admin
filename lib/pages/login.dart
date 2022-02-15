import 'package:admin/pages/dashBord.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with InputValidationMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String message = '';
  final formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width * .2)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formGlobalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Maintenance Service Locator',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Admin Login',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w500)),
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Email'),
                      validator: (email) {
                        return isEmailValid(email!)
                            ? null
                            : 'Enter a valid email address';
                      },
                      controller: email),
                  const Divider(),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                    validator: (password) {
                      return valueRequired(password!) ? null : 'Enter password';
                    },
                    controller: password,
                    obscureText: true,
                  ),
                  const Divider(),
                  ElevatedButton(
                      onPressed: () async {
                        if (formGlobalKey.currentState!.validate()) {
                          formGlobalKey.currentState!.save();
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            if (userCredential.user != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const DashBord()));
                            } else {
                              setState(() {
                                message = 'No user found.';
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                            } else if (e.code == 'wrong-password') {
                              setState(() {
                                message =
                                    'Wrong password provided for that user.';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              message = e.toString();
                            });
                          }
                        }
                      },
                      child:const  Padding(
                        padding:  EdgeInsets.all(10),
                        child: Text('Log In',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                      )),
                  Text(message)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length >= 6;

  bool isEmailValid(String email) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regex.hasMatch(email);
  }

  bool valueRequired(String value) => value.isNotEmpty;
  bool nameRequired(String value) => value.length > 5;
}
