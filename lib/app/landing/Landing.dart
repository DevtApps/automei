import 'package:automei/app/login/LoginModel.dart';
import 'package:automei/app/login/LoginView.dart';
import 'package:automei/app/main/MainModel.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with UserStateModel {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () async {
      initialize();
    });
  }

  initialize() async {
    await reloadUser();
    if (!isLogged()) {
      Navigator.of(context).push(
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1500),
            maintainState: true,
            pageBuilder: (c, a1, a2) {
              return LoginView();
            }),
      );
    } else {
      Navigator.of(context).pushReplacementNamed(MainModel.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "logo",
          child: Image.asset(
            "assets/images/logo.png",
            width: 200,
          ),
        ),
      ),
    );
  }
}
