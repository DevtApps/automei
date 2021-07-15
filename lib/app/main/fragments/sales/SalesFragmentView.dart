import 'package:automei/app/api/model/Order.dart';
import 'package:automei/app/api/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("Mês"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))],
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            builder: (c, snap) {
              if (snap.hasData && snap.data!.docs.isNotEmpty) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> map =
                    snap.data!.docs;

                return ListView.builder(
                  itemBuilder: (c, i) {
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
                                  : Icon(Icons.check, color: Colors.green),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(currency.format(order.value)),
                                  IconButton(
                                      onPressed: () {
                                        print(open[i]);
                                        setState(() {
                                          open[i] =
                                              open[i] != null ? !open[i] : true;
                                        });
                                      },
                                      icon: Icon(
                                        open[i] != null && open[i]
                                            ? Icons.keyboard_arrow_down_outlined
                                            : Icons
                                                .keyboard_arrow_right_outlined,
                                        color: Colors.indigo,
                                      ))
                                ],
                              ),
                              title: Text(
                                order.client?.name,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                  "Pagamento: ${DateFormat("dd/MM").format(DateTime.fromMillisecondsSinceEpoch((order.paymentDate as Timestamp).millisecondsSinceEpoch))}"),
                            ),
                            AnimatedContainer(
                              height: open[i] != null && open[i] ? 200 : 0,
                              duration: Duration(milliseconds: 250),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(order.itens.length,
                                      (index) {
                                    Item? item = order.itens[index];
                                    return Card(
                                        elevation: 0,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: item.product?.photo ==
                                                      "default"
                                                  ? Container(
                                                      width: size.width * 0.12,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/icon_solo.png"),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    size.width),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: size.width * 0.12,
                                                      height: size.width * 0.12,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                              item.product
                                                                  ?.photo,
                                                            ),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    size.width),
                                                      ),
                                                    ),
                                              title: Text(item.product?.name),
                                              trailing: Text(
                                                  "${item.amount}x${currency.format(item.product?.value)}"),
                                            ),
                                          ],
                                        ));
                                  }),
                                ),
                              ),
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
    );
  }
}
