import 'dart:io';

import 'package:automei/app/api/model/Product.dart';
import 'package:automei/app/main/add/product/AddProductView.dart';
import 'package:automei/app/main/add/product/fragment/ChoiceImage.dart';
import 'package:automei/app/util/Alerts.dart';
import 'package:automei/fastfire/models/StorageModel.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

abstract class AddProductModel extends State<AddProductView>
    with StorageModel, UserStateModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var ref = "/products";
  static var route = "add_product";

  FocusNode fieldStock = FocusNode();

  var isStock = true;
  var imagePath;
  late Size size;
  var formKey = GlobalKey<FormState>();

  var scaffold = GlobalKey<ScaffoldState>();

  var nameController = TextEditingController();
  var descController = TextEditingController();
  var valueController = MaskedTextController(mask: "R\$0,00");
  var stockController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    valueController.beforeChange = (before, after) {
      print(before);
      print(after);
      var text =
          after.replaceAll("R\$", "").replaceAll(",", "").replaceAll(".", "");
      if (text.length > 7) {
        return false;
      }
      switch (text.length) {
        case 4:
          valueController.updateMask("R\$00,00");
          break;
        case 5:
          valueController.updateMask("R\$000,00");
          break;
        case 6:
          valueController.updateMask("R\$0.000,00");
          break;
        case 7:
          valueController.updateMask("R\$00.000,00");
          break;
        default:
          valueController.updateMask("R\$0,00");
      }
      //valueController.updateText(text);
      return true;
    };
  }

  void pickImage() async {
    try {
      var source = await ChoiceImage.from(context).choiceSource();
      if (source != null) {
        PickedFile? file = await ImagePicker().getImage(source: source);
        if (file!.path.length > 0) {
          setState(() {
            imagePath = file.path;
          });
        }
      }
    } catch (e) {}
  }

  late PersistentBottomSheetController loadingController;
  var isLoading = false;
  showLoading() {
    setState(() {
      isLoading = true;
    });
    loadingController = scaffold.currentState!.showBottomSheet((c) {
      return Container(
        height: size.height / 2,
        child: Center(
          child: CircularProgressIndicator(
            value: null,
          ),
        ),
      );
    });
    loadingController.closed.then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void saveProduct() async {
    try {
      if (formKey.currentState!.validate()) {
        showLoading();
        var url = "default";
        if (imagePath != null) {
          List<String> result = await uploadFiles(
              [File(imagePath)], ref + "/${auth.currentUser?.uid}");
          if (result.isNotEmpty)
            url = result[0];
          else {
            loadingController.close();
            Alerts.of(context).snack("Houve um erro, tente novamente!");
          }
        }
        Product product = Product();
        product.uid = Uuid().v4(options: {
          "name": nameController.text,
          "user": auth.currentUser?.uid
        });
        product.photo = url;
        product.name = nameController.text;
        product.description = descController.text;
        product.value = double.parse(valueController.text
            .replaceAll("R\$", "")
            .replaceAll(".", "")
            .replaceAll(",", "."));
        if (isStock)
          product.amount = int.parse(stockController.text);
        else
          product.amount = -1;
        product.isStock = isStock;

        await firestore
            .collection("users")
            .doc(auth.currentUser?.uid)
            .collection("stock")
            .add(product.toJson())
            .then((value) {
          loadingController.close();
          Navigator.of(context).pop();
        }).catchError((error) {
          Alerts.of(context).snack("Erro ao cadastrar produto");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  onSuccess(List<String> urls) {
    // TODO: implement onSuccess
    throw UnimplementedError();
  }

  @override
  onError(Exception? e) {
    // TODO: implement onError
    throw UnimplementedError();
  }
}
