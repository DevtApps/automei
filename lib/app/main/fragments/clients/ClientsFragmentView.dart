import 'package:automei/app/api/model/Client.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ClientsFragmentModel.dart';

class ClientsFragmentView extends StatefulWidget {
  var isChoice;
  ClientsFragmentView({this.isChoice = false});
  @override
  _ClientsFragmentViewState createState() => _ClientsFragmentViewState();
}

class _ClientsFragmentViewState extends ClientsFragmentModel {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Consumer<AppStatus>(
      builder: (c, app, child) =>
          child ??
          Container(
            margin: EdgeInsets.only(
                bottom: app.subscriptionStatus!
                    ? 0
                    : BannerSize.STANDARD.height.toDouble()),
            child: Stack(
              children: [
                Scaffold(
                    key: scaffold,
                    body: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: padding.top,
                              color: Colors.indigo[600],
                            ),
                            Container(
                              color: widget.isChoice
                                  ? Colors.white
                                  : Colors.indigo,
                              child: Card(
                                  margin: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (t) {
                                            setState(() {});
                                          },
                                          controller: searchController,
                                          decoration: InputDecoration(
                                              hintText: "Nome...",
                                              contentPadding:
                                                  EdgeInsets.all(16),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.indigoAccent,
                                          )),
                                      SizedBox(
                                        width: 4,
                                      )
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                builder: (c, snap) {
                                  if (snap.hasData &&
                                      snap.data!.docs.isNotEmpty) {
                                    List<
                                            QueryDocumentSnapshot<
                                                Map<String, dynamic>>> map =
                                        snap.data!.docs;
                                    if (searchController.text.isNotEmpty) {
                                      map.removeWhere((element) {
                                        var remove = element
                                            .data()['name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(searchController.text
                                                .toLowerCase());

                                        return !remove;
                                      });
                                    }
                                    if (map.isEmpty)
                                      return Container(
                                        child: Center(
                                          child: Text("Nenhum Resultado"),
                                        ),
                                      );
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (c, index) {
                                        Client client =
                                            Client.fromJson(map[index].data());
                                        return Card(
                                          elevation: 0,
                                          child: ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text(client.name),
                                            subtitle: client.phone
                                                    .toString()
                                                    .isNotEmpty
                                                ? Text(getMask(client.phone))
                                                : client.whatsapp
                                                        .toString()
                                                        .isNotEmpty
                                                    ? Text(getMask(client
                                                        .whatsapp
                                                        .toString()))
                                                    : null,
                                            trailing: IconButton(
                                                onPressed: () {
                                                  if (client.phone
                                                      .toString()
                                                      .isNotEmpty) {
                                                    launch(
                                                        "tel:${client.phone}");
                                                  } else if (client.whatsapp
                                                      .toString()
                                                      .isNotEmpty) {
                                                    launch(
                                                        "https://api.whatsapp.com/send/?phone=55${client.whatsapp}");
                                                  }
                                                },
                                                icon: getIcon(client)),
                                            onTap: () {
                                              onClientClick(client);
                                            },
                                          ),
                                        );
                                      },
                                      itemCount: map.length,
                                    );
                                  } else
                                    return Container(
                                      height: size.height,
                                      alignment: Alignment.center,
                                      child:
                                          Text("Você ainda não tem clientes"),
                                    );
                                },
                                stream: openStreamClients(),
                              ),
                            )
                          ],
                        ),
                        AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                            color: Colors.black
                                .withAlpha(opendedBottomSheet ? 120 : 0),
                            width: size.width,
                            height: opendedBottomSheet ? size.height : 0),
                      ],
                    ),
                    floatingActionButton: !widget.isChoice
                        ? FloatingActionButton.extended(
                            onPressed: onFabClick,
                            label:
                                Text(opendedBottomSheet ? "Salvar" : "Cliente"),
                            icon: Icon(
                                opendedBottomSheet ? Icons.check : Icons.add),
                          )
                        : SizedBox()),
                Visibility(
                  visible: loading,
                  child: Container(
                    height: size.height,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height / 2,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
