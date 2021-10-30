import 'package:automei/app/api/model/Settings.dart' as sett;
import 'package:automei/app/main/fragments/perfil/menu/settings/SettingsView.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class SettingsModel extends State<SettingsView> with UserStateModel {
  static var route = "settings";

  var stockFocus = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  sett.Settings settings = sett.Settings();

  var stockController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    stockController.text = settings.stockLow.toString();

    Future.delayed(Duration(milliseconds: 100), () {
      firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("app")
          .doc("settings")
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            settings = sett.Settings.fromJson(value.data()!);
            stockController.text = settings.stockLow.toString();
          });
        }
      });
    });
  }

  void saveSettings() async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("app")
        .doc("settings")
        .set(settings.toJson());
    setState(() {});
  }
}
