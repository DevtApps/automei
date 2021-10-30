import 'dart:convert';

import 'package:automei/app/api/Api.dart';
import 'package:automei/app/main/fragments/clients/ClientsFragmentView.dart';
import 'package:automei/app/main/fragments/dashboard/DashboardFragmentView.dart';
import 'package:automei/app/main/fragments/perfil/PerfilFragmentView.dart';
import 'package:automei/app/main/fragments/sales/SalesFragmentView.dart';
import 'package:automei/app/main/fragments/stock/StockFragmentView.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'MainView.dart';

abstract class MainModel extends State<MainView> with UserStateModel {
  static var route = "main";

  PageController pageController = PageController();
  int currentPage = 0;
  DashboardFragmentView dashboard = DashboardFragmentView();
  SalesFragmentView sales = SalesFragmentView();
  StockFragmentView stock = StockFragmentView();
  ClientsFragmentView clients = ClientsFragmentView();
  PerfilFragmentView perfil = PerfilFragmentView();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeDateFormatting();
    createCustomer();
  }

  void createCustomer() async {
    var profile = await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("app")
        .doc("profile")
        .get();
    if (!profile.exists) {
      final url = Uri.parse('$URL/create-customer');
      final response = await post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': await auth.currentUser!.getIdToken()
        },
        body: json.encode({
          'email': auth.currentUser?.email,
        }),
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        profile.reference.set({"customerId": body['id']});
      }
    }
  }
}
