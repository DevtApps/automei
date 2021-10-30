import 'package:automei/app/api/model/Client.dart';
import 'package:automei/app/main/add/client/AddClientModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

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

  var phoneController = MaskedTextController(mask: "(00) 0 0000-0000");

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

  showAddClient({client}) async {
    setState(() {
      opendedBottomSheet = true;
      if (client != null) isUpdate = true;
    });
    var controller = scaffold.currentState?.showBottomSheet((c) {
      return Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          height: size.height / 2,
          child: AddClient());
    }, elevation: 10);
    controller?.closed.then((value) {
      setState(() {
        isUpdate = false;
        opendedBottomSheet = false;
      });
    });
  }

  void onClientClick(Client mClient) {
    if (widget.isChoice) {
      Navigator.of(context).pop(mClient);
    } else {
      client = mClient;
      showAddClient(client: client);
    }
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
      return Image.asset(
        "assets/images/whatsapp.png",
        width: 28,
        color: Colors.indigo,
      );
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

  getMask(String text) {
    phoneController.updateText(text);
    return phoneController.text;
  }

  Widget AddClient() {
    if (isUpdate) {
      nameController.text = client.name;
      phoneController.updateText(client.phone);
      whatsappController.updateText(client.whatsapp);
      cpfController.updateText(client.cpf);
      stateController.text = client.state;
      cityController.text = client.city;
      districtController.text = client.district;
      streetController.text = client.street;
      numberController.text = client.number;
    }
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
