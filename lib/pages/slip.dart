import 'package:admin/pages/dashBord.dart';
import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SlipPage extends StatefulWidget {
  const SlipPage({
    required this.uid,
    Key? key,
  }) : super(key: key);
  final String uid;

  @override
  State<SlipPage> createState() => _SlipPageState();
}

class _SlipPageState extends State<SlipPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('paid')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Image.network(data!['url']),
                        // Container(
                        //   decoration: BoxDecoration(
                        //   image: DecorationImage(image: NetworkImage(data!['url']),fit: BoxFit.contain)
                        // ),),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(3333))
                                    .then((value) {
                                  if (value != null && value != selectedDate) {
                                    setState(() {
                                      selectedDate = value;
                                    });
                                  }
                                });
                              },
                              child: Text(
                                selectedDate.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              CollectionReference license = FirebaseFirestore
                                  .instance
                                  .collection('license');

                              license.doc(widget.uid).set({
                                'useTo': selectedDate,
                              }).then((value) async {
                                await FirebaseFirestore.instance
                                    .collection('paid')
                                    .doc(widget.uid)
                                    .delete();
                              });
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const DashBord()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'OK',
                                style: TextStyle(fontSize: 22),
                              ),
                            )),
                        const SizedBox(
                          height: 20.0,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }
                return const Loading();
              })),
    );
  }
}
