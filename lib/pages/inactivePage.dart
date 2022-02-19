// ignore_for_file: file_names

import 'package:admin/widget/customList.dart';
import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InactivatePage extends StatelessWidget {
  const InactivatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('maintenanceDetail')
            .where('active', isEqualTo: true)
            .snapshots(),
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
              user: false,
              slip: false,
            );
          }
          return const Loading();
        });
  }
}
