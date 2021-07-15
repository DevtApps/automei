import 'package:automei/app/main/MainModel.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends MainModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
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
        ));
  }
}
