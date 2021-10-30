import 'package:automei/app/api/Api.dart';
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
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  var filterDate = 30;

  List<Map> filterList = [
    {"title": "24H", "value": 1},
    {"title": "Semana", "value": 7},
    {"title": "Mês", "value": 30},
    {"title": "Sempre", "value": 0},
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> openStreamSales() {
    var now = DateTime.now();

    CollectionReference<Map<String, dynamic>> collection =
        firestore.collection("sales");

    if (filterDate > 0)
      return collection
          .where("account", isEqualTo: auth.currentUser!.uid)
          .where("date",
              isGreaterThan: now.subtract(
                Duration(
                    days: filterDate, hours: now.hour, minutes: now.minute),
              ))
          .snapshots();
    else
      return collection.snapshots();
  }

  void openFilter() {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(filterList.length + 1, (index) {
                  if (index == 0)
                    return ListTile(
                      title: Text(
                        "Mostrar a partir de",
                        style: TextStyle(color: Colors.indigo, fontSize: 18),
                      ),
                    );
                  index--;
                  return Container(
                    margin: EdgeInsets.only(top: 4),
                    child: ListTile(
                      tileColor: Colors.indigoAccent.shade200,
                      title: Text(
                        filterList[index]['title'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          filterDate = filterList[index]['value'];
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                }),
              ),
            ),
          );
        });
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

  void payed(Order order) async {
    await firestore
        .collection("sales")
        .doc(order.uid)
        .update({"status": order.status == 1 ? 0 : 1});
  }
}
