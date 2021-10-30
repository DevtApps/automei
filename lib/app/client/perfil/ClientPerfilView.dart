import 'package:automei/app/client/perfil/ClientPerfilModel.dart';
import 'package:flutter/material.dart';

class ClientPerfilView extends StatefulWidget {
  const ClientPerfilView({Key? key}) : super(key: key);

  @override
  _ClientPerfilViewState createState() => _ClientPerfilViewState();
}

class _ClientPerfilViewState extends ClientPerfilModel {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Container(
                  height: size.height * 0.3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 2, child: SizedBox()),
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 70,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.indigoAccent,
                              borderRadius: BorderRadius.circular(size.width)),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Tiago",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                        TabBar(
                            unselectedLabelColor: Colors.black,
                            labelColor: Colors.indigo,
                            controller: tabController,
                            tabs: [
                              Tab(
                                iconMargin: EdgeInsets.all(0),
                                child: Text("Conta"),
                              ),
                              Tab(
                                iconMargin: EdgeInsets.all(0),
                                child: Text("Vendas"),
                              ),
                              Tab(
                                text: "Informações",
                              ),
                            ])
                      ],
                    ),
                  ),
                ),
              ),
              PageView()
            ],
          ),
        ),
      ),
    );
  }
}
