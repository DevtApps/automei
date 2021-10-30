import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppView extends StatefulWidget {
  static var route = "update";
  @override
  _UpdateAppViewState createState() => _UpdateAppViewState();
}

class _UpdateAppViewState extends State<UpdateAppView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              Center(
                  child: Image.asset(
                "assets/images/logo.png",
                width: size.width * 0.5,
              )),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  "Seu app está desatualizado, por favor, atualze para obter as principais novidades!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ]),
            Container(
              width: size.width * 0.7,
              child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(20),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.indigo)),
                onPressed: () {
                  launch(
                      "https://play.google.com/store/apps/details?id=com.appside.automei");
                },
                child: Text(
                  "Atualizar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
