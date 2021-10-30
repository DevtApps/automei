import 'package:automei/app/api/AppAds.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class AppStatus with ChangeNotifier, UserStateModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RemoteConfig config = RemoteConfig.instance;
  bool? subscriptionStatus;
  bool? isLoading = false;
  AppAds ads = AppAds();

  var context;
  void setStatusSubscription(value) {
    subscriptionStatus = value == 1;
    notifyListeners();
  }

  void showLoading() {
    isLoading = true;
    notifyListeners();
  }

  void removeLoading() {
    isLoading = false;
    notifyListeners();
  }

  AppStatus(this.context) {
    // listenSubscription();
  }

  void listenSubscription() {
    firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("subscription")
        .snapshots()
        .listen((event) {
      var doc = event.docChanges.first;
    });
  }
}
