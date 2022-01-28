import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

Future<firebase_storage.ListResult> listFiles(String dir, String uid) async {
  firebase_storage.ListResult result =
      await storage.ref('$dir/$uid').listAll().onError((error, stackTrace) {
    throw Exception(error);
  });

  return result;
}

Future<void> changeState(String id) async {
  CollectionReference detail =
      FirebaseFirestore.instance.collection('maintenanceDetail');

  detail.doc(id).update({
    'active': true,
  }).then((_) {
    debugPrint('status changed successfully');
  });
}

Future<void> disableAccount(String id, bool user) async {
  CollectionReference detail = FirebaseFirestore.instance
      .collection(user ? 'userDetail' : 'maintenanceDetail');
  CollectionReference disable =
      FirebaseFirestore.instance.collection('diisable');

  detail.doc(id).update({
    'disable': true,
  }).then((_) {
    disable.doc(id).set({});
    debugPrint('Account Disabled');
  });
}
