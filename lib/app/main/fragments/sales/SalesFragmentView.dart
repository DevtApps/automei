import 'dart:ffi';

import 'package:automei/app/api/Api.dart';
import 'package:automei/app/api/model/Order.dart';
import 'package:automei/app/api/model/Product.dart';
import 'package:automei/app/client/perfil/ClientPerfilView.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'SalesFragmentModel.dart';

class SalesFragmentView extends StatefulWidget {
  @override
  _SalesFragmentViewState createState() => _SalesFragmentViewState();
}

class _SalesFragmentViewState extends SalesFragmentModel {
  var open = {};
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
              appBar: AppBar(
                brightness: Brightness.dark,
                title: Text(filterList.firstWhere(
                    (element) => element['value'] == filterDate)['title']),
                actions: [
                  IconButton(
                      onPressed: openFilter, icon: Icon(Icons.filter_list))
                ],
              ),
              body: Stack(
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    builder: (c, snap) {
                      if (snap.hasData && snap.data!.docs.isNotEmpty) {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>> map =
                            snap.data!.docs;

                        var list = [];
                        var a = 0;
                        if (map.length > 5 && !app.subscriptionStatus!) {
                          for (var i = 0; i < map.length; i++) {
                            a++;
                            if (a == 6) {
                              list.add(null);
                              a = 0;
                            } else
                              list.add(map[i]);
                          }
                        } else
                          list.addAll(map);

                        print(list);
                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: 70),
                          itemBuilder: (c, i) {
                            if (list[i] == null) {
                              return app.ads.getNativeBanner(size);
                            } else {
                              Order order = Order.fromJson(map[i].data());
                              return Card(
                                  elevation: 1,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          /* Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      ClientPerfilView()));
                                                      */
                                        },
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
                                            Text(currency.format(order.value)),
                                            IconButton(
                                                onPressed: () {
                                                  print(open[i]);
                                                  setState(() {
                                                    open[i] = open[i] != null
                                                        ? !open[i]
                                                        : true;
                                                  });
                                                },
                                                icon: Icon(
                                                  open[i] != null && open[i]
                                                      ? Icons
                                                          .keyboard_arrow_up_outlined
                                                      : Icons
                                                          .keyboard_arrow_down_outlined,
                                                  color: Colors.indigo,
                                                ))
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
                                      AnimatedContainer(
                                        height: open[i] != null && open[i]
                                            ? (70 * order.itens.length)
                                                    .toDouble() +
                                                70
                                            : 0,
                                        duration: Duration(milliseconds: 250),
                                        child: SingleChildScrollView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              SingleChildScrollView(
                                                child: Column(
                                                  children: List.generate(
                                                      order.itens.length,
                                                      (index) {
                                                    Item? item =
                                                        order.itens[index];
                                                    return Card(
                                                        elevation: 0,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              leading: item
                                                                          .product
                                                                          ?.photo ==
                                                                      "default"
                                                                  ? Container(
                                                                      width: size
                                                                              .width *
                                                                          0.12,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image:
                                                                                AssetImage("assets/images/icon_solo.png"),
                                                                            fit: BoxFit.cover),
                                                                        borderRadius:
                                                                            BorderRadius.circular(size.width),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: size
                                                                              .width *
                                                                          0.12,
                                                                      height: size
                                                                              .width *
                                                                          0.12,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              item.product?.photo,
                                                                            ),
                                                                            fit: BoxFit.cover),
                                                                        borderRadius:
                                                                            BorderRadius.circular(size.width),
                                                                      ),
                                                                    ),
                                                              title: Text(item
                                                                  .product
                                                                  ?.name),
                                                              trailing: Text(
                                                                  "${item.amount}x${currency.format(item.product?.value)}"),
                                                            ),
                                                          ],
                                                        ));
                                                  }),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              CheckboxListTile(
                                                  title: Text(order.status == 1
                                                      ? "Pagamento confirmado"
                                                      : "Aguardando pagamento"),
                                                  value: order.status == 1,
                                                  onChanged: (val) {
                                                    payed(order);
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            }
                          },
                          itemCount: list.length,
                        );
                      } else
                        return Container(
                          height: size.height,
                          alignment: Alignment.center,
                          child: Text("Nenhuma venda aqui"),
                        );
                    },
                    stream: openStreamSales(),
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
