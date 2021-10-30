import 'package:automei/app/api/model/Product.dart';
import 'package:automei/app/main/fragments/stock/StockFragmentModel.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockFragmentView extends StatefulWidget {
  var isChoice;
  StockFragmentView({this.isChoice: false});
  @override
  _StockFragmentViewState createState() => _StockFragmentViewState();
}

class _StockFragmentViewState extends StockFragmentModel {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<AppStatus>(
      builder: (c, app, child) =>
          child ??
          Container(
            margin: EdgeInsets.only(
                bottom: app.subscriptionStatus!
                    ? 0
                    : BannerSize.STANDARD.height.toDouble()),
            child: Scaffold(
              appBar: !widget.isChoice
                  ? AppBar(
                      brightness: Brightness.dark,
                      title: Text("Todos"),
                      actions: [],
                    )
                  : null,
              body: Column(
                children: [
                  Card(
                      margin: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (t) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  hintText: "Produto...",
                                  contentPadding: EdgeInsets.all(16),
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: Colors.indigoAccent,
                              )),
                          SizedBox(
                            width: 4,
                          )
                        ],
                      )),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      builder: (c, snap) {
                        print(searchController.text);
                        if (snap.hasData && snap.data!.docs.isNotEmpty) {
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              map = snap.data!.docs;
                          if (searchController.text.isNotEmpty) {
                            map.removeWhere((element) {
                              var remove = element
                                  .data()['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase());
                              print(remove);
                              return !remove;
                            });
                          }
                          if (map.isEmpty)
                            return Container(
                              child: Center(
                                child: Text("Nenhum Resultado"),
                              ),
                            );
                          return ListView.builder(
                            itemBuilder: (c, i) {
                              Product product = Product.fromJson(map[i].data());
                              return Card(
                                  elevation: 1,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: product.photo == "default"
                                            ? Container(
                                                width: size.width * 0.14,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/icon_solo.png"),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width),
                                                ),
                                              )
                                            : Container(
                                                width: size.width * 0.14,
                                                height: size.width * 0.14,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        product.photo,
                                                      ),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width),
                                                ),
                                              ),
                                        title: Text(product.name),
                                        subtitle: product.isStock
                                            ? Text("${product.amount} uni")
                                            : Text("não estocável"),
                                        trailing: Text(
                                            currency.format(product.value)),
                                        onTap: () {
                                          onProductClick(product);
                                        },
                                      ),
                                    ],
                                  ));
                            },
                            itemCount: map.length,
                          );
                        } else
                          return Container(
                            height: size.height,
                            alignment: Alignment.center,
                            child: Text("Não há produtos cadastrados"),
                          );
                      },
                      stream: openStreamProducts(),
                    ),
                  ),
                ],
              ),
              floatingActionButton: !widget.isChoice
                  ? FloatingActionButton.extended(
                      heroTag: "heroFab",
                      onPressed: addProcuct,
                      label: Text("Produto"),
                      icon: Icon(Icons.add),
                    )
                  : SizedBox(),
            ),
          ),
    );
  }
}
