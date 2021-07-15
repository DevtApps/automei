import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChoiceImage {
  var context;
  ChoiceImage.from(this.context);

  Future<dynamic> choiceSource() async {
    return await showModalBottomSheet(
        builder: (c) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Câmera"),
                onTap: () {
                  Navigator.of(c).pop(ImageSource.camera);
                },
              ),
              ListTile(
                title: Text("Galeria"),
                onTap: () {
                  Navigator.of(c).pop(ImageSource.gallery);
                },
              ),
            ],
          );
        },
        context: context);
  }
}
