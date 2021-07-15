import 'package:automei/app/api/model/Client.dart';
import 'package:automei/app/api/model/Order.dart';
import 'package:automei/app/api/model/Product.dart';
import 'package:automei/app/main/fragments/clients/ClientsFragmentView.dart';
import 'package:automei/app/main/fragments/sales/fragment/ChoiceDate.dart';
import 'package:automei/app/main/fragments/sales/fragment/FastsellFragment.dart';
import 'package:automei/app/main/fragments/stock/StockFragmentView.dart';
import 'package:automei/app/util/Alerts.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'SalesFragmentView.dart';

abstract class SalesFragmentModel extends State<SalesFragmentView>
    with UserStateModel {
  var scaffold = GlobalKey<ScaffoldState>();
  NumberFormat currency =
      NumberFormat.currency(locale: "pt-BR", symbol: "R\$", decimalDigits: 2);
  late Size size;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isFastSale = false;
  late PersistentBottomSheetController fastController;

  late FastsellFragment fastsellFragment;

  Stream<QuerySnapshot<Map<String, dynamic>>> openStreamSales() {
    return firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("sales")
        .snapshots();
  }

  void sell() async {
    if (!isFastSale) {
      fastSell();
    } else {
      await fastsellFragment.onTap();
      fastController.close();
    }
  }

  void fastSell() {
    setState(() {
      isFastSale = true;
    });

    fastsellFragment = FastsellFragment();

    fastController = scaffold.currentState!.showBottomSheet((c) {
      return fastsellFragment;
    }, backgroundColor: Colors.transparent);

    fastController.closed.then((value) {
      setState(() {
        isFastSale = false;
      });
    });
  }
}
