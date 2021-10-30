import 'package:automei/app/client/perfil/ClientPerfilView.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ClientPerfilModel extends State<ClientPerfilView>
    with UserStateModel, SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }
}
