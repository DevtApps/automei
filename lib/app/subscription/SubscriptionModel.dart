import 'dart:convert';

import 'package:automei/app/api/controller/SubscriptionController.dart';
import 'package:automei/app/api/model/Subscription.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:automei/app/subscription/fragment/ConfirmView.dart';
import 'package:automei/app/util/Alerts.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'SubscriptionView.dart';

abstract class SubscriptionModel extends State<SubscriptionView>
    with UserStateModel {
  static var route = "subscription";

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late SubscriptionController subscriptionController;
  var scaffold = GlobalKey<ScaffoldState>();

  Size? size;

  Future<void> onPayment() async {
    try {
      Provider.of<AppStatus>(context, listen: false).showLoading();
      var profile = await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("app")
          .doc("profile")
          .get();
      if (!profile.exists) {
        Alerts.of(context).snack("Seu perfil está incompleto");
      } else {
        var subscription = await subscriptionController
            .createSubscription(profile.data()!['customerId']);
        if (subscription == null) throw new Exception("subscription null");

        print(subscription);
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          style: ThemeMode.light,
          testEnv: true,
          merchantCountryCode: 'BR',
          merchantDisplayName: 'Automei',
          customerId: profile.data()!['customerId'],
          paymentIntentClientSecret: subscription['clientSecret'],
          customerEphemeralKeySecret: subscription['ephemeralKey'],
        ));

        try {
          Provider.of<AppStatus>(context, listen: false).removeLoading();
          await Stripe.instance.presentPaymentSheet();
          //await Stripe.instance.confirmPaymentSheetPayment();
          Provider.of<AppStatus>(context, listen: false).showLoading();

          Subscription mSubscription = Subscription();
          // mSubscription.paymentIntent = subscription['intent'];
          mSubscription.subscriptionId = subscription['subscriptionId'];

          mSubscription.status = 1;

          //print(mSubscription.toJson());

          await firestore
              .collection("users")
              .doc(auth.currentUser?.uid)
              .collection("app")
              .doc("subscription")
              .set(mSubscription.toJson());

          await SubscriptionController(context).statusSubscription();

          Navigator.of(context).pushReplacementNamed("subscribe_success");
        } on StripeException catch (e) {
          //print(e);
          if (e.error.code == FailureCode.Failed) {
            Alerts.of(context)
                .snack("Desculpe, não foi possível processar sua assinatura!");
          } else if (e.error.code == FailureCode.Canceled) {
            Alerts.of(context)
                .snack("Processamento cancelado!", color: Colors.indigo);
          }
        } catch (e) {
          print(e);
          Alerts.of(context).snack("Desculpe, houve um problema!");
        }
      }
    } catch (e) {}

    Provider.of<AppStatus>(context, listen: false).removeLoading();
  }

  void cancelSubscription() async {
    Provider.of<AppStatus>(context, listen: false).showLoading();
    var result = await subscriptionController.cancelSubscription();
    subscriptionController.statusSubscription();
    //print(result);
    if (result) {
      Alerts.of(context).snack("Assinatura cancelada", color: Colors.green);
    } else
      Alerts.of(context).snack("Assinatura inativa ou não encontrada");
    Provider.of<AppStatus>(context, listen: false).removeLoading();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      subscriptionController = SubscriptionController(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }
}
