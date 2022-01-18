import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisableAccount extends StatelessWidget {
  const DisableAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('complain').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return data.isEmpty
                ? const Center(
                    child: Text('No Complain'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:Text( data[index]['to']),
                        subtitle: Text(data[index]['message']),
                        trailing: Text(data[index]['who']),
                      );
                    });
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            throw Exception(snapshot.error);
          }
          return const Loading();
        });
  }
}