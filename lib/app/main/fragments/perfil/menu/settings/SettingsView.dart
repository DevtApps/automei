import 'package:automei/app/main/fragments/perfil/menu/settings/SettingsModel.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends SettingsModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
        ),
        body: ListView(
          padding: EdgeInsets.all(4),
          children: [
            Card(
              child: Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Baixo estoque a partir de",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    TextField(
                      focusNode: stockFocus,
                      keyboardType: TextInputType.number,
                      onChanged: (t) {
                        setState(() {});
                      },
                      controller: stockController,
                      decoration: InputDecoration(
                        filled: true,
                        suffixIcon: stockController.text !=
                                    settings.stockLow.toString() &&
                                stockController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  stockFocus.unfocus();
                                  settings.stockLow =
                                      int.parse(stockController.text);
                                  saveSettings();
                                },
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
