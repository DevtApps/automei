import 'package:automei/app/api/controller/SubscriptionController.dart';
import 'package:automei/app/update/UpdateAppView.dart';
import 'package:automei/app/login/LoginView.dart';
import 'package:automei/app/main/MainModel.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with UserStateModel {
  late SubscriptionController subscriptionController;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () async {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      OneSignal.shared.setAppId("8041af09-6da3-4eee-9b20-8e00aad6b220");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        print("Accepted permission: $accepted");
      });
      subscriptionController = SubscriptionController(context);
      await subscriptionController.statusSubscription();
      initialize();
    });
  }

  initialize() async {
    await reloadUser();
    if (!isLogged()) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 700),
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
