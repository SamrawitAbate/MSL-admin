import 'package:admin/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  const CustomList({Key? key, required this.snapshot
  ,required this.accept,required this.user
  }) : super(key: key);
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final bool user,  accept;
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
                      .collection('rate')
                      .doc(id)
                      .get(),
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      if (snapshot2.data!['rate'] < 2) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title:
                                Text(snapshot.data!.docs[index].id.toString()),
                            trailing: Text('Rating ${snapshot2.data!['rate']}'),
                            subtitle: Text('${t.toLocal()}'.split(' ')[0]),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                          uid: snapshot.data!.docs[index].id, accept: accept, user: user,disable: false,)));
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
