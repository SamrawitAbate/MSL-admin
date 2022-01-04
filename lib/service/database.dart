import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

Future<firebase_storage.ListResult> listFiles(String dir, String uid) async {


 
  firebase_storage.ListResult result = await storage.ref('$dir/$uid').listAll().onError((error, stackTrace) {
    throw Exception(error);
  });
  result.items.forEach((firebase_storage.Reference ref) {
   debugPrint('Found $ref');
  });
  return result;
}
Future<void> changeState(String id) async {
  CollectionReference detail = FirebaseFirestore.instance.collection('maintenanceDetail');

  detail.doc(id).update({
    'active': true,
  }).then((_) {
    debugPrint('status changed successfully');
  });
}
