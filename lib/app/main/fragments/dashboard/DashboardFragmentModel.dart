import 'package:automei/app/api/model/Settings.dart' as sett;
import 'package:automei/app/main/fragments/sales/SalesFragmentModel.dart';
import 'package:automei/app/main/fragments/sales/fragment/FastsellFragment.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DashboardFragmentView.dart';

abstract class DashboardFragmentModel extends State<DashboardFragmentView>
    with UserStateModel {
  var scaffold = GlobalKey<ScaffoldState>();
  NumberFormat currency =
      NumberFormat.currency(locale: "pt-BR", symbol: "R\$", decimalDigits: 2);
  late Size size;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isFastSale = false;
  late PersistentBottomSheetController fastController;
  late FastsellFragment fastsellFragment;
  var stockLow = 10;

  Stream<QuerySnapshot<Map<String, dynamic>>> openStreamLastSales() {
    return firestore
        .collection("sales")
        .where(
          "date",
          isGreaterThan: DateTime.now().subtract(
            Duration(days: 7),
          ),
        )
        .where("account", isEqualTo: auth.currentUser!.uid)
        .orderBy("date", descending: true)
        .limit(5)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> openStreamStock() {
    return firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("stock")
        .where("amount", isLessThan: stockLow, isGreaterThan: -1)
        .orderBy("amount")
        .limit(5)
        .snapshots();
  }

  getHeader() async {
    var header = {};
    var result = await firestore
        .collection("sales")
        .where("date",
            isGreaterThan: DateTime.now().subtract(Duration(days: 7)))
        .where("account", isEqualTo: auth.currentUser!.uid)
        .get();
    header['sales'] = result.docs.length;
    var total = 0.0;
    var notReceived = 0.0;
    for (var data in result.docs) {
      if (data.data()['status'] == 1)
        total += data.data()['value'];
      else
        notReceived += data.data()['value'];
    }
    header['value'] = total;
    header['notReceived'] = notReceived;

    return header;
  }

  void sell() async {
    if (!isFastSale) {
      fastSell();
    } else {
      var result = await fastsellFragment.onTap();
      print(result);
      if (result != null && result) fastController.close();
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

  @override
  void initState() {
    super.initState();

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
            var settings = sett.Settings.fromJson(value.data()!);
            stockLow = settings.stockLow;
            print(stockLow);
          });
        }
      });
    });
  }
}
