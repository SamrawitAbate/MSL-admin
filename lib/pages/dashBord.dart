// ignore_for_file: file_names

import 'package:admin/pages/disableList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'activatePage.dart';
import 'customer.dart';
import 'home.dart';
import 'inactivePage.dart';
import 'login.dart';

class DashBord extends StatefulWidget {
  const DashBord({Key? key}) : super(key: key);

  @override
  _DashBordState createState() => _DashBordState();
}

class _DashBordState extends State<DashBord> {
  final TextStyle style = TextStyle(
      color: Colors.green.shade600, fontSize: 20, fontWeight: FontWeight.w700);
  int curentIndex = 0;
  List<Widget> pages = [
    const Home(),
    const ActivatePage(),
    const InactivatePage(),
    const Customer(),
    const DisableAccount()
  ];
  bool minValue = false;
  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      inkButton(1, 'Inactive service provider', context),
      inkButton(2, 'Active service provider', context),
      inkButton(3, 'Customer', context),
      inkButton(4, 'Disable Account', context),
      IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const Login()));
          },
          icon: const Icon(Icons.logout))
    ];
    setState(() {
      minValue = MediaQuery.of(context).size.width < 820;
    });
    return Scaffold(
      drawer: minValue
          ? Drawer(
              child: Column(
                children: buttons,
              ),
            )
          : const SizedBox(),
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                setState(() {
                  curentIndex = 0;
                });
              },
              icon: Icon(
                Icons.home_filled,
                color: curentIndex == 0 ? Colors.green : Colors.white,
              )),
          actions: minValue ? [] : buttons),
      body: pages[curentIndex],
    );
  }

  inkButton(index, lable, context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.center,
            child: InkWell(
                onTap: () {
                  minValue ? Navigator.pop(context) : 0;
                  setState(() {
                    curentIndex = index;
                  });
                },
                child: Text(lable,
                    style: curentIndex == index ? style : const TextStyle()))));
  }
}
