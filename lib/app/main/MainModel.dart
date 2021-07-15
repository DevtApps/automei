import 'package:automei/app/main/fragments/clients/ClientsFragmentView.dart';
import 'package:automei/app/main/fragments/dashboard/DashboardFragmentView.dart';
import 'package:automei/app/main/fragments/perfil/PerfilFragmentView.dart';
import 'package:automei/app/main/fragments/sales/SalesFragmentView.dart';
import 'package:automei/app/main/fragments/stock/StockFragmentView.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeDateFormatting();
  }
}
