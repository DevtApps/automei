import 'package:flutter/material.dart';

class SuccessSubscribe extends StatefulWidget {
  static var route = "subscribe_success";
  SuccessSubscribe();

  @override
  _SuccessSubscribeState createState() => _SuccessSubscribeState();
}

class _SuccessSubscribeState extends State<SuccessSubscribe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          Image.asset(
            "assets/images/checked (1).png",
            width: 100,
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              "Parabéns, você assinou o plano Start",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "e agora está livre de propagandas",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                child: Card(
                  child: Container(
                    width: 160,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Voltar",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
