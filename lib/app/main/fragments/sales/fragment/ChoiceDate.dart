import 'package:flutter/material.dart';

class ChoiceDate extends StatefulWidget {
  @override
  _ChoiceDateState createState() => _ChoiceDateState();
}

class _ChoiceDateState extends State<ChoiceDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DatePickerDialog(
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        initialDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 1)),
        selectableDayPredicate: (date) {
          return true;
        },
      ),
    );
  }
}
