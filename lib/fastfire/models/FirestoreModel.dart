import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirestoreModel implements UserStateModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> openStreamProducts() {
    return firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("stock")
        .snapshots();
  }
}
