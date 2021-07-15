import 'package:automei/app/landing/Landing.dart';
import 'package:automei/app/login/LoginModel.dart';
import 'package:automei/app/login/LoginView.dart';
import 'package:automei/app/main/MainModel.dart';
import 'package:automei/app/main/MainView.dart';
import 'package:automei/app/main/add/product/AddProductModel.dart';
import 'package:automei/app/main/add/product/AddProductView.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Automei',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Landing(),
      routes: {
        LoginModel.route: (c) => LoginView(),
        MainModel.route: (c) => MainView(),
        AddProductModel.route: (c) => AddProductView()
      },
    );
  }
}
