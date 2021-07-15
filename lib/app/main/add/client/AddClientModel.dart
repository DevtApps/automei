import 'package:automei/app/api/model/Client.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddClientModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var nameController = TextEditingController();
  var stateController = TextEditingController();
  var cityController = TextEditingController();
  var districtController = TextEditingController();
  var streetController = TextEditingController();
  var numberController = TextEditingController();

  var phoneController = MaskedTextController(mask: "(00) 0 0000-0000");
  var whatsappController = MaskedTextController(mask: "(00) 0 0000-0000");
  var cpfController = MaskedTextController(mask: "000.000.000-00");

  var formKey = GlobalKey<FormState>();

  Future<bool> saveClient() async {
    if (formKey.currentState!.validate()) {
      Client client = Client();
      client.name = nameController.text;
      client.phone = phoneController.text;
      client.whatsapp = whatsappController.text;
      client.cpf = cpfController.text;
      client.state = stateController.text;
      client.city = cityController.text;
      client.street = streetController.text;
      client.district = districtController.text;
      client.number = numberController.text;
      client.uid = Uuid().v4(options: {
        "name": nameController.text,
        "user": auth.currentUser!.uid
      });

      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("clients")
          .add(client.toJson());
      return true;
    }
    return false;
  }
}
