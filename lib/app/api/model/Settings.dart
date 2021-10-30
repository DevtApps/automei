class Settings {
  var stockLow = 10;

  Settings();
  Settings.fromJson(Map<String, dynamic> map) {
    stockLow = map['stockLow'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['stockLow'] = this.stockLow;
    return map;
  }
}
