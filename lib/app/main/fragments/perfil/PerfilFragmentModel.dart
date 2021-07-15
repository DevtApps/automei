import 'package:automei/app/main/fragments/perfil/PerfilFragmentView.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:flutter/material.dart';

abstract class PerfilFragmentModel extends State<PerfilFragmentView>
    with UserStateModel {
  ScrollController scrollController = ScrollController();

  var isTop = false;

  Size size = Size(0, 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      print("${scrollController.offset} is more ${size.height * 0.1}");
      print(isTop);
      if (scrollController.offset >= size.height * 0.1 && !isTop) {
        setState(() {
          isTop = true;
        });
      } else if (scrollController.offset < size.height * 0.1 && isTop) {
        setState(() {
          isTop = false;
        });
      }
    });
  }
}
