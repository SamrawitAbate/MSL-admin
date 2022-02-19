import 'package:admin/widget/customList.dart';
import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Customer extends StatelessWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('userDetail').snapshots(),
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

          if (snapshot.hasData) {
            return CustomList(
              snapshot: snapshot,
              accept: false,
              user: true,
              slip: false,
            );
          }
          return const Loading();
        });
  }
}
