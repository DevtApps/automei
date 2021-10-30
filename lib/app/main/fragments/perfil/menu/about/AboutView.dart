import 'package:flutter/material.dart';

class AboutView extends StatefulWidget {
  static var route = "about";
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(18),
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 100,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Center(
                child: Text(
                  "Automei busca agilizar e gerenciar as suas vendas, mantenha o controle de seus clientes, produtos, vendas e faturamento!",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          )),
    );
  }
}
