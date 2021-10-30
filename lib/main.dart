import 'package:automei/app/animation/LoadingView.dart';
import 'package:automei/app/landing/Landing.dart';
import 'package:automei/app/login/LoginModel.dart';
import 'package:automei/app/login/LoginView.dart';
import 'package:automei/app/main/MainModel.dart';
import 'package:automei/app/main/MainView.dart';
import 'package:automei/app/main/add/product/AddProductModel.dart';
import 'package:automei/app/main/add/product/AddProductView.dart';
import 'package:automei/app/main/fragments/perfil/menu/about/AboutView.dart';
import 'package:automei/app/main/fragments/perfil/menu/settings/SettingsModel.dart';
import 'package:automei/app/main/fragments/perfil/menu/settings/SettingsView.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:automei/app/subscription/SubscriptionModel.dart';
import 'package:automei/app/subscription/SubscriptionView.dart';
import 'package:automei/app/subscription/fragment/SuccessSubscribe.dart';
import 'package:automei/app/update/UpdateAppView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var STRIPE_LIVE =
      "pk_live_51IdJOZEEmyOoEDXUZ3xQ1Eu93KJ8LJKaJaKVHWEYgnytmls35WwBtuqvYYvkA2aBBtfrVuRSmwyf4hI9WifKz1Hh002UgdWhHH";

  var STRIPE_DEV =
      "pk_test_51IdJOZEEmyOoEDXUigX8RCUCS7YMBrVXdporbn5dIbKEWw2DYpvBuw7iKrZUCM9pqGA3HTRTqBZQfNupW2tEhmea00knFXnKHM";
  MobileAds.instance.initialize();
  FacebookAudienceNetwork.init(
      //testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
      );
  Stripe.publishableKey = kReleaseMode ? STRIPE_LIVE : STRIPE_DEV;
  Firebase.initializeApp().then((value) async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);

    runApp(
      MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (c) => AppStatus(c),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Automei',
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: Landing(),
          builder: (c, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                child!,
                LoadingView(),
              ],
            );
          },
          routes: {
            LoginModel.route: (c) => LoginView(),
            MainModel.route: (c) => MainView(),
            AddProductModel.route: (c) => AddProductView(),
            SettingsModel.route: (c) => SettingsView(),
            UpdateAppView.route: (c) => UpdateAppView(),
            AboutView.route: (c) => AboutView(),
            SubscriptionModel.route: (c) => SubscriptionView(),
            SuccessSubscribe.route: (c) => SuccessSubscribe()
          },
        ));
  }
}
