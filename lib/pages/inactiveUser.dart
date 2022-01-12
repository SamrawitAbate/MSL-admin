import 'package:admin/pages/profile.dart';
import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InactiveUser extends StatefulWidget {
  const InactiveUser({Key? key}) : super(key: key);

  @override
  _InactiveUserState createState() => _InactiveUserState();
}

class _InactiveUserState extends State<InactiveUser> {
  Stream<QuerySnapshot>? _iC;
  @override
  void initState() {
    super.initState();
    _iC = FirebaseFirestore.instance
        .collection('userDetail')
        .where('active', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
            stream: _iC,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                return snapshot.data!.docs.isEmpty
                ? const Center(
                    child: Text('No Data'),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Timestamp t = snapshot.data!.docs[index]['registerDate'];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index].id.toString()),
                          subtitle: Text(t.toDate().toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                        uid: snapshot.data!.docs[index].id)));
                          },
                        ),
                      );
                    });
              }
              return const Loading();
            });
  }
}
