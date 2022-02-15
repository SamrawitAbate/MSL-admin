// ignore_for_file: file_names

import 'package:admin/pages/profile.dart';
import 'package:admin/pages/slip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  const CustomList(
      {Key? key,
      required this.snapshot,
      required this.accept,
      required this.user,required this.slip})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final bool user, accept,slip;
  @override
  Widget build(BuildContext context) {
    return snapshot.data!.docs.isEmpty
        ? const Center(
            child: Text('No Data'),
          )
        : ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DateTime t =
                  snapshot.data!.docs[index]['registeredDate'].toDate();
              String id = snapshot.data!.docs[index].id;

              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection(user?'CRate':'SPRate')
                      .doc(id)
                      .get(),
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      if (snapshot2.data!['rate'] < 2) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('account')
                                    .doc(snapshot.data!.docs[index].id)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snap) {
                                  if (snap.hasError) {
                                    return Text('Error = ${snap.error}');
                                  }
                                  if (snap.hasData) {
                                    var data = snap.data!;
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage(data['photoUrl']),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            data['fullName'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Container();
                                }),
                            trailing: Text('Rating ${snapshot2.data!['rate']}'),
                            subtitle: Text('${t.toLocal()}'.split(' ')[0]),
                            onTap: () {
                              slip?Navigator.push(context, MaterialPageRoute(builder: (context)=>SlipPage(uid: snapshot.data!.docs[index].id))):
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                            uid: snapshot.data!.docs[index].id,
                                            accept: accept,
                                            user: user,
                                            disable: false,
                                          )));
                            },
                          ),
                        );
                      }
                    }
                    return Container();
                  });
            });
  }
}
