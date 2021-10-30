import 'package:automei/app/api/model/Product.dart';
import 'package:automei/app/main/MainModel.dart';
import 'package:automei/app/main/add/product/AddProductModel.dart';

import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'StockFragmentView.dart';

abstract class StockFragmentModel extends State<StockFragmentView>
    with UserStateModel {
  NumberFormat currency =
      NumberFormat.currency(locale: "pt-BR", symbol: "R\$", decimalDigits: 2);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void addProcuct() async {
    await Navigator.of(context).pushNamed(AddProductModel.route);
    setState(() {
      widget.isChoice = false;
    });
  }

  var searchController = TextEditingController();

  Stream<QuerySnapshot<Map<String, dynamic>>> openStreamProducts() {
    return firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("stock")
        .snapshots();
  }

  void onProductClick(Product product) async {
    if (widget.isChoice) {
      Navigator.of(context).pop(product);
    } else {
      await Navigator.of(context)
          .pushNamed(AddProductModel.route, arguments: product);
      setState(() {
        widget.isChoice = false;
      });
    }
  }
}
