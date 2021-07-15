class Client {
  var uid;
  var name;
  var phone;
  var whatsapp;
  var cpf;
  var street;
  var number;
  var district;
  var city;
  var state;

  Client();
  Client.fromJson(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    phone = map['phone'];
    whatsapp = map['whatsapp'];
    cpf = map['cpf'];
    street = map['street'];
    number = map['number'];
    district = map['district'];
    city = map['city'];
    state = map['state'];
  }

  toJson() {
    Map<String, dynamic> map = Map();
    map['uid'] = this.uid;
    map['name'] = this.name;
    map['phone'] = this.phone;
    map['whatsapp'] = this.whatsapp;
    map['cpf'] = this.cpf;
    map['street'] = this.street;
    map['number'] = this.number;
    map['district'] = this.district;
    map['city'] = this.city;
    map['state'] = this.state;

    return map;
  }
}
