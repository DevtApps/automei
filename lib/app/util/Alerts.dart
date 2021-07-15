import 'package:flutter/material.dart';

class Alerts {
  var context;
  Alerts.of(this.context);
  snack(String message, {MaterialColor color: Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
