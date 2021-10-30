import 'package:automei/app/api/model/Order.dart';
import 'package:automei/app/api/model/Product.dart';
import 'package:automei/app/main/fragments/dashboard/DashboardFragmentModel.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardFragmentView extends StatefulWidget {
  @override
  _DashboardFragmentViewState createState() => _DashboardFragmentViewState();
}

class _DashboardFragmentViewState extends DashboardFragmentModel {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;

    return Consumer<AppStatus>(
      builder: (c, app, child) =>
          child ??
          Container(
            margin: EdgeInsets.only(
                bottom: app.subscriptionStatus!
                    ? 0
                    : BannerSize.STANDARD.height.toDouble()),
            child: Scaffold(
              key: scaffold,
              body: Stack(
                children: [
                  ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 18, bottom: 18, left: 18, right: 18),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  auth.currentUser!.displayName!,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.16,
                              height: size.width * 0.16,
                              decoration: auth.currentUser?.photoURL !=
                                      "default"
                                  ? BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              auth.currentUser!.photoURL!)),
                                      borderRadius:
                                          BorderRadius.circular(size.width))
                                  : BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/logo.png"),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(size.width)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 18),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Esta Semana",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      FutureBuilder(
                        builder: (c, snap) {
                          if (snap.hasData) {
                            return Container(
                              height: size.width * 0.36,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    margin: EdgeInsets.only(
                                        left: 16, bottom: 12, top: 12),
                                    child: Container(
                                        width: size.width * 0.9,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(22),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      currency.format((snap.data
                                                          as Map)['value']),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: size.width *
                                                              0.07),
                                                    )),
                                                Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "faturamento",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.width *
                                                              0.035),
                                                    )),
                                                Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "a receber ${currency.format((snap.data as Map)['notReceived'])}",
                                                      style: TextStyle(
                                                          color: Colors.yellow,
                                                          fontSize: size.width *
                                                              0.035),
                                                    )),
                                              ],
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(right: 18),
                                                child: Icon(
                                                  Icons.monetization_on,
                                                  size: size.width * 0.12,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        )),
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    margin: EdgeInsets.all(16),
                                    child: Container(
                                        width: size.width * 0.9,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(22),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "${(snap.data as Map)['sales']}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 29),
                                                    )),
                                                Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "vendas",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(right: 18),
                                                child: Icon(
                                                  Icons.shopping_cart,
                                                  size: size.width * 0.12,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            );
                          } else
                            return Container(
                              height: size.height * 0.18,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: null,
                                ),
                              ),
                            );
                        },
                        future: getHeader(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 18),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Últimas Vendas",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        builder: (c, snap) {
                          if (snap.hasData) {
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                map = snap.data!.docs;
                            if (map.isEmpty)
                              return ListTile(
                                title: Text(
                                    "Suas vendas recentes aparecerão aqui"),
                              );
                            else
                              return Column(
                                  children: List.generate(
                                map.length,
                                (i) {
                                  Order order = Order.fromJson(map[i].data());
                                  return Card(
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: order.status == 0
                                                ? Icon(
                                                    Icons.timelapse,
                                                    color: Colors.red,
                                                  )
                                                : Icon(Icons.check,
                                                    color: Colors.green),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(currency
                                                    .format(order.value)),
                                              ],
                                            ),
                                            title: Text(
                                              order.client?.name,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Text(
                                                "Pagamento: ${DateFormat("dd/MM").format(DateTime.fromMillisecondsSinceEpoch((order.paymentDate as Timestamp).millisecondsSinceEpoch))}"),
                                          ),
                                        ],
                                      ));
                                },
                              ));
                          } else
                            return Container();
                        },
                        stream: openStreamLastSales(),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 18),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Baixo Estoque",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        builder: (c, snap) {
                          print(snap.error);
                          if (snap.hasData) {
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                map = snap.data!.docs;

                            if (map.isEmpty)
                              return ListTile(
                                title: Text(
                                    "Seus produtos com baixo estoque aparecerão aqui"),
                              );
                            else
                              return Column(
                                  children: List.generate(
                                map.length,
                                (i) {
                                  Product product =
                                      Product.fromJson(map[i].data());

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
                                          ),
                                        ],
                                      ));
                                },
                              ));
                          } else
                            return Container();
                        },
                        stream: openStreamStock(),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                      color: Colors.black.withAlpha(isFastSale ? 120 : 0),
                      width: size.width,
                      height: isFastSale ? size.height : 0),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: sell,
                label: Text(isFastSale ? "Concluir" : "Vender"),
                icon: Icon(isFastSale ? Icons.check : Icons.sell),
              ),
            ),
          ),
    );
  }
}
