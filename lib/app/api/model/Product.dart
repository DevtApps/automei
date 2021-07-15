class Product {
  var uid;
  var name;
  var value;
  var description;
  var photo;
  int amount = 0;
  var isStock;

  Product();
  Product.fromJson(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    value = map['value'];
    description = map['description'];
    photo = map['photo'];
    amount = map['amount'];
    isStock = map['isStock'];
  }

  toJson() {
    Map<String, dynamic> map = Map();
    map['uid'] = this.uid;
    map['name'] = this.name;
    map['value'] = this.value;
    map['description'] = this.description;
    map['photo'] = this.photo;
    map['amount'] = this.amount;
    map['isStock'] = this.isStock;

    return map;
  }
}
