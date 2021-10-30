import 'package:automei/app/api/Api.dart';
import 'package:automei/app/main/MainModel.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends MainModel {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<AppStatus>(
      builder: (c, app, child) => Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                dashboard,
                sales,
                stock,
                clients,
                perfil,
              ],
            ),
            !app.subscriptionStatus! ? app.ads.getMainBanner(size) : SizedBox()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
            pageController.jumpToPage(
              index,
            );
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "vendas"),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "estoque"),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: "clientes"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "perfil"),
          ],
        ),
      ),
    );
  }
}
