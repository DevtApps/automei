import 'package:automei/app/api/controller/SubscriptionController.dart';
import 'package:automei/app/api/model/Subscription.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:automei/app/util/Alerts.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

import 'package:provider/provider.dart';

class ConfirmView extends StatefulWidget {
  var clientSecret;
  var params;
  var subscriptionId;
  ConfirmView({this.clientSecret, this.params, this.subscriptionId});

  @override
  _ConfirmViewState createState() => _ConfirmViewState();
}

class _ConfirmViewState extends State<ConfirmView> with UserStateModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/images/undraw_data_reports_706v.png"),
          ),
          Container(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Resumo",
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
                        width: size.width * 0.5,
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
                    "Confirmar Assinatura do plano Start?",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
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
                Card(
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Assinando com ",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          "assets/images/GPay.png",
                          width: 50,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: size.width * 0.7,
                  child: Card(
                    child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(16))),
                        child: Text(
                          "Assinar",
                          style: TextStyle(fontSize: 18, color: Colors.indigo),
                        ),
                        onPressed: () async {
                          Provider.of<AppStatus>(context, listen: false)
                              .showLoading();
                          stripe.PaymentIntent intent =
                              await stripe.Stripe.instance.confirmPayment(
                            widget.clientSecret,
                            widget.params,
                          );
                          Subscription subscription = Subscription();
                          subscription.paymentIntent = intent;
                          subscription.subscriptionId = widget.subscriptionId;
                          if (intent.status ==
                              stripe.PaymentIntentsStatus.Succeeded) {
                            subscription.status = 1;
                          }

                          await firestore
                              .collection("users")
                              .doc(auth.currentUser?.uid)
                              .collection("app")
                              .doc("subscription")
                              .set(subscription.toJson());
                          await SubscriptionController(context)
                              .statusSubscription();

                          Provider.of<AppStatus>(context, listen: false)
                              .removeLoading();
                          Navigator.of(context)
                              .pushReplacementNamed("subscribe_success");
                        }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
