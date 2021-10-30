import 'package:automei/app/login/LoginModel.dart';
import 'package:automei/app/main/fragments/perfil/PerfilFragmentModel.dart';
import 'package:automei/app/main/fragments/perfil/menu/about/AboutView.dart';
import 'package:automei/app/main/fragments/perfil/menu/settings/SettingsModel.dart';
import 'package:automei/app/provider/AppStatus.dart';
import 'package:automei/app/subscription/SubscriptionModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilFragmentView extends StatefulWidget {
  @override
  _PerfilFragmentViewState createState() => _PerfilFragmentViewState();
}

class _PerfilFragmentViewState extends PerfilFragmentModel {
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;
    size = MediaQuery.of(context).size;
    return Consumer<AppStatus>(
      builder: (c, app, child) => Scaffold(
        backgroundColor: Colors.indigoAccent,
        body: Stack(
          children: [
            Column(children: [
              SizedBox(
                height: padding.top + size.height * 0.01,
              ),
              Container(
                alignment: Alignment.center,
                height: size.height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/logo.png",
                        width: 40, color: Colors.white),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Automei",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            ]),
            SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(height: padding.top + size.height * 0.1),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.only(),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  !isTop ? size.width * 0.5 : 0))
                          //color: Colors.indigo,
                          ),
                      child: Container(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              width: size.width * 0.3,
                              height: size.width * 0.3,
                              decoration: auth.currentUser?.photoURL !=
                                      "default"
                                  ? BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              auth.currentUser!.photoURL!)),
                                      borderRadius:
                                          BorderRadius.circular(size.width))
                                  : BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/logo.png"),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(size.width)),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  auth.currentUser!.displayName!,
                                  style: TextStyle(
                                      color: Colors.indigoAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: app.subscriptionStatus! ? 8 : 0,
                                ),
                                Visibility(
                                  visible: app.subscriptionStatus!,
                                  child: Icon(Icons.check_circle_outlined,
                                      color: Colors.green),
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            Card(
                              margin: EdgeInsets.only(left: 32, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.indigoAccent,
                                        ),
                                        title: Text("Assinatura"),
                                        trailing: Icon(
                                          Icons.credit_card,
                                          color: Colors.indigoAccent,
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              SubscriptionModel.route);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin:
                                  EdgeInsets.only(left: 32, top: 8, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.indigoAccent,
                                        ),
                                        title: Text("Configurações"),
                                        trailing: Icon(
                                          Icons.settings,
                                          color: Colors.indigoAccent,
                                        ),
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(SettingsModel.route);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin:
                                  EdgeInsets.only(left: 32, top: 8, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.indigoAccent,
                                        ),
                                        title: Text("Sobre"),
                                        trailing: Icon(
                                          Icons.info,
                                          color: Colors.indigoAccent,
                                        ),
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(AboutView.route);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            /*Card(
                              margin:
                                  EdgeInsets.only(left: 32, top: 8, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.indigoAccent,
                                        ),
                                        title: Text("Não ver anúncios hoje"),
                                        trailing: Icon(
                                          Icons.info,
                                          color: Colors.indigoAccent,
                                        ),
                                        onTap: () {
                                          dayFree();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),*/
                            Card(
                              margin:
                                  EdgeInsets.only(left: 32, top: 8, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.red,
                                        ),
                                        title: Text("Sair"),
                                        trailing: Icon(
                                          Icons.exit_to_app,
                                          color: Colors.red,
                                        ),
                                        onTap: () async {
                                          await auth.signOut();
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  LoginModel.route);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
