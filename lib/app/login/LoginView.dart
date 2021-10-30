import 'package:automei/app/animation/LoadingView.dart';
import 'package:automei/app/login/LoginModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends LoginModel {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
        key: scaffold,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: padding.top + 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Hero(
                          tag: "logo",
                          child: Image.asset("assets/images/logo.png",
                              width: size.height * 0.12),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Automei",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: size.height * 0.035,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: size.width * 0.1, right: size.width * 0.1),
                      child: Form(
                        key: formKey,
                        child: ListView(
                          children: [
                            AnimatedContainer(
                              height: isRegister ? size.height * 0.11 : 0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.decelerate,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 4),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Nome",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: nameController,
                                      validator: (text) {
                                        if (isRegister) {
                                          return text!.isEmpty
                                              ? "Informe um nome"
                                              : null;
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.blueAccent)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Colors.blueAccent),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.red),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.red),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "E-mail",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
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
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.blueAccent)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.blueAccent),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Senha",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                            TextFormField(
                              controller: passwordController,
                              validator: (value) => value!.length > 5
                                  ? null
                                  : "Senha com mínimo de 6 digitos",
                              obscureText: true,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.blueAccent)),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              height: isRegister ? 0 : 20,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.ease,
                              margin: EdgeInsets.only(bottom: 4, top: 8),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Text(
                                  "Esqueceu a senha?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.indigoAccent),
                                ),
                                onTap: () {
                                  forgetPassword();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            AnimatedCrossFade(
                                firstChild: LoginButton(),
                                secondChild: RegisterButton(),
                                crossFadeState: isRegister
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 400)),
                            SizedBox(
                              height: 16,
                            ),
                            AnimatedCrossFade(
                                firstChild: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text("Não tem uma conta?"),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 4),
                                        child: Text(
                                          "Cadastre-se",
                                          style: TextStyle(
                                              color: Colors.indigoAccent,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isRegister = !isRegister;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                secondChild: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 4),
                                        child: Text(
                                          "Já tenho uma conta",
                                          style: TextStyle(
                                              color: Colors.indigoAccent,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          isRegister = !isRegister;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                crossFadeState: isRegister
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 400)),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 12, right: 12),
                                  child: Text("ou"),
                                ),
                                Expanded(
                                  child: Divider(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      width: 40,
                                      child: Image.asset(
                                          "assets/images/search.png"),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    googleSignIn();
                                  },
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  child: Card(
                                    color: Colors.blue[800],
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      width: 40,
                                      child: Image.asset(
                                        "assets/images/facebook.png",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    facebookSignIn();
                                  },
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                    child: Card(
                                      color: Colors.black54,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        width: 40,
                                        child: Image.asset(
                                          "assets/images/github.png",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      signInWithGitHub(context);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
                child: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black.withAlpha(140),
                ),
                visible: isReset),
            Visibility(visible: loading, child: LoadingView()),
          ],
        ));
  }
}
