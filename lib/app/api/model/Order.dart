import 'package:automei/app/api/model/Client.dart';
import 'package:automei/app/api/model/Product.dart';

class Order {
  var uid;
  List<Item> itens = [];
  var value;
  Client? client;
  var paymentDate;
  int status = 0;
  var isOpen = false;
  var date;
  Order();

  Order.fromJson(Map<String, dynamic> map) {
    uid = map['uid'];
    date = map["date"];
    itens = getItens(map['itens']);
    value = map['value'];
    client = Client.fromJson(map['client']);
    paymentDate = map['paymentDate'];
    status = map['status'];
  }

  toJson() {
    Map<String, dynamic> map = Map();
    map['date'] = this.date;
    map['uid'] = this.uid;
    map['itens'] = getItensMap(itens);
    map['value'] = this.value;
    map['client'] = this.client?.toJson();
    map['paymentDate'] = this.paymentDate;
    map['status'] = this.status;
    return map;
  }

  getItensMap(List<Item> itens) {
    List<Map<String, dynamic>> list = [];
    for (Item item in itens) {
      list.add(item.toJson());
    }
    return list;
  }

  getItens(List itens) {
    List<Item> list = [];
    for (Map<String, dynamic> data in itens) {
      list.add(Item.fromJson(data));
    }
    return list;
  }
}

class Item {
  Product? product;
  int amount;

  Item(this.product, {this.amount: 1});

  toJson() {
    Map<String, dynamic> map = Map();
    map['product'] = this.product?.toJson();
    map['amount'] = this.amount;
    return map;
  }

  static fromJson(Map<String, dynamic> map) {
    return Item(Product.fromJson(map['product']), amount: map['amount']);
  }
}
