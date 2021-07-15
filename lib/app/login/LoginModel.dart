import 'package:automei/app/main/MainModel.dart';
import 'package:automei/app/util/Alerts.dart';
import 'package:automei/app/interface/OnResultAuth.dart';
import 'package:automei/fastfire/models/SocialSignInModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginView.dart';

abstract class LoginModel extends State<LoginView> with SocialSignInModel {
  static var route = "login";
  var isRegister = false;

  var loading = false;
  var isReset = false;
  var formKey = GlobalKey<FormState>();
  var scaffold = GlobalKey<ScaffoldState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  late Size size;
  @override
  void onError(Exception? e, int code) {
    Alerts.of(context).snack("Tente novamente!");
    setState(() {
      loading = false;
    });
  }

  @override
  void onSuccess(UserCredential? user) async {
    if (user!.additionalUserInfo!.isNewUser) {
      if (user.credential != null &&
          user.credential!.signInMethod == "github.com") {
        var info = user.additionalUserInfo!.profile;
        await user.user!.updateDisplayName(user.additionalUserInfo!.username);
        await user.user!.updatePhotoURL(info!['avatar_url']);
        setState(() {
          loading = false;
        });
        Navigator.of(context).pushReplacementNamed(MainModel.route);
      } else {
        Navigator.of(context).pushReplacementNamed(MainModel.route);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(MainModel.route);
    }
  }

  Widget LoginButton() {
    return TextButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.white.withAlpha(50)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width))),
            backgroundColor: MaterialStateProperty.all(Colors.indigoAccent)),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(12),
          child: Text(
            "Entrar",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: signIn);
  }

  signIn() async {
    setState(() {
      loading = true;
    });
    if (formKey.currentState!.validate()) {
      signInEmail(emailController.text, passwordController.text);
    }
  }

  signOut() async {
    setState(() {
      loading = true;
    });
    if (formKey.currentState!.validate()) {
      signOutEmail(emailController.text, passwordController.text,
          name: nameController.text);
    }
  }

  Widget RegisterButton() {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.white.withAlpha(50)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width))),
          backgroundColor: MaterialStateProperty.all(Colors.indigoAccent)),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        child: Text(
          "Cadastrar",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      onPressed: signOut,
    );
  }

  late PersistentBottomSheetController bottom;
  forgetPassword() {
    setState(() {
      isReset = true;
    });
    var resetEmailController = TextEditingController();
    var load = false;
    bottom = scaffold.currentState!.showBottomSheet((c) {
      return Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(32),
          height: size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Enviaremos um email para recuperar sua senha",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w700)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "E-mail",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  TextFormField(
                    controller: resetEmailController,
                    validator: (text) {
                      return text!.contains("@") && text.length > 8
                          ? null
                          : "E-email inválido";
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueAccent)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(width: 2, color: Colors.blueAccent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(width: 2, color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(width: 2, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.white.withAlpha(50)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.width))),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.indigoAccent)),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  child: load
                      ? Center(
                          child: Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              value: null,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        )
                      : Text(
                          "Enviar",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                ),
                onPressed: () async {
                  if (resetEmailController.text.contains("@") &&
                      resetEmailController.text.length > 6) {
                    bottom.setState!(() {
                      load = true;
                    });
                    await auth.sendPasswordResetEmail(
                        email: resetEmailController.text);
                    Navigator.of(c).pop();
                  } else
                    Alerts.of(context).snack("E-mail inválido");
                },
              )
            ],
          ),
        ),
      );
    });
    bottom.closed.then((value) {
      setState(() {
        isReset = false;
      });
    });
  }
}
