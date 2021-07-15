import 'package:automei/app/api/model/Client.dart';
import 'package:automei/app/main/add/client/AddClientModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ClientsFragmentView.dart';

abstract class ClientsFragmentModel extends State<ClientsFragmentView>
    with AddClientModel {
  var scaffold = GlobalKey<ScaffoldState>();
  var opendedBottomSheet = false;
  late Size size;
  var loading = false;
  var searchController = TextEditingController();

  onFabClick() async {
    if (opendedBottomSheet) {
      setState(() {
        loading = true;
      });
      var result = await saveClient();
      setState(() {
        loading = false;
      });
      if (result) {
        Navigator.of(context).pop();
      }
    } else {
      showAddClient();
    }
  }

  showAddClient() async {
    setState(() {
      opendedBottomSheet = true;
    });
    var controller = scaffold.currentState?.showBottomSheet((c) {
      return Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          height: size.height / 2,
          child: AddClient());
    }, elevation: 10);
    controller?.closed.then((value) {
      setState(() {
        opendedBottomSheet = false;
      });
    });
  }

  void onClientClick(Client client) {
    if (widget.isChoice) {
      Navigator.of(context).pop(client);
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.addListener(() {
      phoneController.selection = new TextSelection.fromPosition(
          new TextPosition(offset: phoneController.text.length));
    });
    whatsappController.addListener(() {
      whatsappController.selection = new TextSelection.fromPosition(
          new TextPosition(offset: whatsappController.text.length));
    });
    cpfController.addListener(() {
      cpfController.selection = new TextSelection.fromPosition(
          new TextPosition(offset: cpfController.text.length));
    });
  }

  Widget getIcon(Client client) {
    if (client.whatsapp.toString().isNotEmpty) {
      return SizedBox();
    } else if (client.phone.toString().isNotEmpty) {
      return Icon(
        Icons.phone,
        color: Colors.indigoAccent,
      );
    } else
      return SizedBox();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> openStreamClients() {
    return firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .collection("clients")
        .snapshots();
  }

  Widget AddClient() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.all(4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Informações",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.indigo),
                      )),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Nome",
                        filled: true,
                        border: InputBorder.none,
                      ),
                      validator: (text) {
                        return text!.isNotEmpty ? null : "Informe um nome";
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Telefone",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: TextFormField(
                      controller: whatsappController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Whatsapp",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: TextFormField(
                      controller: cpfController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "CPF",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Endereço",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.indigo),
                      )),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: TextFormField(
                      controller: stateController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Estado",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: TextFormField(
                      controller: cityController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Cidade",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    child: TextFormField(
                      controller: districtController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Bairro",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: TextFormField(
                            controller: streetController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: "Rua",
                              filled: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: TextFormField(
                            controller: numberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Número",
                              filled: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
