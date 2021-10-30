import 'package:automei/app/provider/AppStatus.dart';
import 'package:automei/app/subscription/SubscriptionModel.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  _SubscriptionViewState createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends SubscriptionModel {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Consumer<AppStatus>(
      builder: (c, app, child) => Scaffold(
        key: scaffold,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 68,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tome o controle",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 6,
                        width: size!.width * 0.5,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 46,
                ),
                Container(
                  child: Text(
                    "Comece agora a gerenciar suas vendas, seu estoque, seus clientes e suas datas\nPare agora com dúvidas e dificuldades com estoque, ou aquela dor de cabeça para lembrar de tudo\nAssine e tenha tudo isso em suas mãos a hora que quiser livre de propagandas",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                app.subscriptionStatus!
                    ? Container(
                        width: size!.width * 0.7,
                        child: Card(
                          color: Colors.red,
                          child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(16))),
                              child: Text(
                                "Cancelar Assinatura",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              onPressed: cancelSubscription),
                        ),
                      )
                    : Column(children: [
                        Center(
                          child: Text(
                            "Plano Start",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigoAccent),
                          ),
                        ),
                        Center(
                          child: Text(
                            "R\$4,99/mês",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Text(
                            "* Remoção de propagandas",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: size!.width * 0.7,
                          child: Card(
                            color: Colors.indigo,
                            child: TextButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(16))),
                                child: Text(
                                  "ASSINAR",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                onPressed: onPayment),
                          ),
                        )
                      ]),
                Container(
                  alignment: Alignment.center,
                  child:
                      Image.asset("assets/images/undraw_data_reports_706v.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
