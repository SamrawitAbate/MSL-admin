import 'package:admin/widget/customList.dart';
import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivatePage extends StatelessWidget {
  const ActivatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('maintenanceDetail')
            .where('active', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return CustomList(
              snapshot: snapshot,
              accept: true,
              user: false,
            );
          }
          return const Loading();
        });
  }
}
