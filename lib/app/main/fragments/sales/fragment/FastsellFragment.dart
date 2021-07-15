import 'package:automei/app/api/model/Client.dart';
import 'package:automei/app/api/model/Order.dart';
import 'package:automei/app/api/model/Product.dart';
import 'package:automei/app/interface/OnClick.dart';
import 'package:automei/app/main/fragments/clients/ClientsFragmentView.dart';
import 'package:automei/app/main/fragments/stock/StockFragmentView.dart';
import 'package:automei/app/util/Alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FastsellFragment extends StatefulWidget implements OnClick {
  _FastsellFragmentState state = _FastsellFragmentState();

  @override
  _FastsellFragmentState createState() => state;

  @override
  onTap() {
    state.onTap();
  }
}

class _FastsellFragmentState extends State<FastsellFragment>
    implements OnClick {
  NumberFormat currency =
      NumberFormat.currency(locale: "pt-BR", symbol: "R\$", decimalDigits: 2);
  Order order = Order();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FocusNode nameFocus = FocusNode();

  Future<Product?> choiceProduct() {
    return showModalBottomSheet<Product>(
        context: context,
        builder: (c) {
          return StockFragmentView(
            isChoice: true,
          );
        });
  }

  Future<Client?> choiceClient() {
    return showModalBottomSheet<Client>(
        context: context,
        builder: (c) {
          return ClientsFragmentView(
            isChoice: true,
          );
        });
  }

  Future<DateTime?> choiceDate() {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

  getTotal(Order order) {
    double total = 0.0;
    for (var item in order.itens) {
      total += item.amount * item.product?.value;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 16,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Container(
        height: size.height / 2,
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 22,
              ),
              order.client?.uid != null
                  ? ListTile(
                      title: Text(order.client?.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () async {
                                Client? client = await choiceClient();
                                if (client != null) {
                                  setState(() {
                                    order.client = client;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.indigo,
                              )),
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  order.client = null;
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ))
                  : Row(
                      children: [
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.all(4),
                          child: TextFormField(
                            focusNode: nameFocus,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: "Cliente",
                              filled: true,
                            ),
                            onChanged: (text) {
                              if (text.isNotEmpty) {
                                setState(() {
                                  Client client = Client();
                                  client.name = text;
                                  order.client = client;
                                });
                              } else {
                                setState(() {
                                  order.client = null;
                                });
                              }
                            },
                            validator: (text) {
                              return text!.isNotEmpty
                                  ? null
                                  : "Informe um nome";
                            },
                          ),
                        )),
                        SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () async {
                              Client? client = await choiceClient();
                              if (client != null) {
                                setState(() {
                                  order.client = client;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.group_sharp,
                              color: Colors.indigo,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
              CheckboxListTile(
                  title: Text("Marcar como pago"),
                  value: order.status == 1,
                  onChanged: (val) {
                    order.paymentDate = val! ? DateTime.now() : null;
                    setState(() {
                      order.status = val ? 1 : 0;
                    });
                  }),
              AnimatedContainer(
                height: order.status == 0 ? 60 : 0,
                duration: Duration(milliseconds: 250),
                child: Visibility(
                  visible: order.status == 0,
                  maintainState: true,
                  maintainAnimation: true,
                  child: ListTile(
                    title: Text(
                        order.paymentDate != null
                            ? "Receber em"
                            : "Selecione uma data de pagamento",
                        style: TextStyle(fontSize: 16)),
                    trailing: order.paymentDate != null
                        ? Text(DateFormat("dd/MM").format(order.paymentDate),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18))
                        : Container(
                            child: Icon(Icons.date_range, color: Colors.indigo),
                            margin: EdgeInsets.only(
                              right: 8,
                            ),
                          ),
                    onTap: () async {
                      nameFocus.unfocus();
                      DateTime? date = await choiceDate();
                      if (date != null) {
                        setState(() {
                          order.paymentDate = date;
                        });
                      }
                    },
                  ),
                ),
              ),
              Container(
                  child: ListTile(
                title: Text(
                  "TOTAL",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                ),
                trailing: Text(
                  currency.format(getTotal(order)),
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
              )),
              Container(
                  margin: EdgeInsets.all(4),
                  child: ListTile(
                      title: Text("Adicionar um produto",
                          style: TextStyle(color: Colors.black)),
                      trailing: Icon(Icons.add, color: Colors.indigo),
                      onTap: () async {
                        nameFocus.unfocus();
                        Product? product = await choiceProduct();
                        if (product != null) {}
                        setState(() {
                          order.itens.add(Item(product));
                        });
                      })),
              Column(
                children: List.generate(order.itens.length, (index) {
                  return Dismissible(
                    behavior: HitTestBehavior.translucent,
                    background: Container(
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 8),
                    ),
                    key: Key("$index"),
                    onDismissed: (direction) {
                      setState(() {
                        order.itens.removeAt(index);
                      });
                    },
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        title: Text(order.itens[index].product?.name),
                        subtitle: Text(
                            currency.format(order.itens[index].product?.value)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  if (order.itens[index].amount > 1) {
                                    setState(() {
                                      order.itens[index].amount -= 1;
                                    });
                                  }
                                },
                                child: Text(
                                  "-",
                                  style: TextStyle(fontSize: 18),
                                )),
                            Text(
                              "${order.itens[index].amount}",
                              style: TextStyle(fontSize: 18),
                            ),
                            TextButton(
                                onPressed: () {
                                  print(order.toString());
                                  if (order.itens[index].amount <
                                      order.itens[index].product!.amount) {
                                    setState(() {
                                      order.itens[index].amount += 1;
                                    });
                                  }
                                },
                                child:
                                    Text("+", style: TextStyle(fontSize: 18))),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  onTap() async {
    if (order.itens.isNotEmpty &&
        order.paymentDate != null &&
        order.client != null) {
      order.value = getTotal(order);
      order.uid = Uuid().v4(options: {
        "user": auth.currentUser?.uid,
        "date": DateTime.now().millisecondsSinceEpoch
      });
      order.date = DateTime.now();
      await firestore
          .collection("users")
          .doc(auth.currentUser?.uid)
          .collection("sales")
          .add(order.toJson());

      order = Order();
    } else {
      Alerts.of(context).snack("Complete todos os campos");
    }
  }
}
