class Subscription {
  var paymentIntent;
  var subscriptionId;
  var status = 0;

  toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    //map['paymentIntent'] = this.paymentIntent.toJson() ?? '';
    map['subscriptionId'] = this.subscriptionId;
    map['status'] = this.status;
    return map;
  }
}
