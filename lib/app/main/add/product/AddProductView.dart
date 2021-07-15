import 'dart:io';

import 'package:automei/app/main/add/product/AddProductModel.dart';
import 'package:flutter/material.dart';

class AddProductView extends StatefulWidget {
  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends AddProductModel {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      key: scaffold,
      body: ListView(
        children: [
          imagePath != null ? photoView(size) : addPhoto(size),
          Container(
            margin: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        labelText: "Nome",
                      ),
                      validator: (text) {
                        return text!.isEmpty ? "Informe um nome" : null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: descController,
                      minLines: 4,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        labelText: "Descrição",
                      ),
                      validator: (text) {
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: valueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        labelText: "valor",
                      ),
                      validator: (text) {
                        return text!
                                .replaceAll("R\$", "")
                                .replaceAll(".", "")
                                .replaceAll(",", "")
                                .isEmpty
                            ? "Informe o valor"
                            : null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: CheckboxListTile(
                      value: isStock,
                      onChanged: (val) {
                        setState(() {
                          isStock = val!;
                          if (!val) fieldStock.unfocus();
                          //print(isStock);
                        });
                      },
                      title: Text("Terá estoque?"),
                    ),
                  ),
                  AnimatedContainer(
                    height: isStock ? size.height * 0.1 : 0,
                    margin: EdgeInsets.only(bottom: 12),
                    duration: Duration(milliseconds: 600),
                    curve: Curves.ease,
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      controller: stockController,
                      focusNode: fieldStock,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        labelText: "quantidade (estoque)",
                      ),
                      validator: (text) {
                        try {
                          if (isStock) {
                            int.parse(text!);
                            return text.isEmpty ? "Informe o estoque" : null;
                          }
                        } catch (e) {
                          return "Valor inválido";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isLoading
          ? SizedBox()
          : FloatingActionButton.extended(
              onPressed: saveProduct,
              icon: Icon(Icons.check),
              label: Text("Adicionar")),
    );
  }

  Widget addPhoto(Size size) {
    return Container(
      color: Colors.grey.withAlpha(50),
      width: size.width * 0.3,
      height: size.height * 0.3,
      child: IconButton(
        icon: Icon(
          Icons.add_a_photo,
          color: Colors.white,
          size: size.width * 0.2,
        ),
        onPressed: pickImage,
      ),
    );
  }

  Widget photoView(Size size) {
    return GestureDetector(
      child: Container(
        height: size.height * 0.5,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Colors.grey.withAlpha(50),
              width: size.width,
              height: size.height * 0.3,
              child: imagePath.toString().startsWith("http")
                  ? Image.network(imagePath, fit: BoxFit.cover)
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: pickImage,
                child: Icon(Icons.edit),
              ),
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
