import 'package:admin/service/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:html' as html;
import 'loading.dart';

class ListFile extends StatelessWidget {
  const ListFile({Key? key, required this.dir, required this.uid})
      : super(key: key);
  final String dir;
  final String uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listFiles(dir, uid),
        builder: (BuildContext context,
            AsyncSnapshot<firebase_storage.ListResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return snapshot.data!.items.isEmpty
                ? const Center(
                    child: Text('No Data'),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  String url = await snapshot.data!.items[index]
                                      .getDownloadURL();
                                  html.window.open(url, '_blank');
                                },
                                child: Text(snapshot.data!.items[index].name)),
                          );
                        }),
                  );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Loading();
          }
          return Container();
        });
  }
}
