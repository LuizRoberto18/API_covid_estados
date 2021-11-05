import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'estados.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dados;
  int totalCasos = 0;
  int totalMortes = 0;
  bool carregado = false;

  getInfoVirus() async {
    //api fora do ar
    String url = "https://alertacorona.online/data.json";
    http.Response response;
    response = await http.get(url);
    if (response.statusCode == 200) {
      var decodeJson = jsonDecode(response.body);
      return decodeJson['Brasil']['states'];
    }
  }

  @override
  void initState() {
    super.initState();
    getInfoVirus().then((map) {
      setState(() {
        print(map);
        dados = map;
        for (var i = 0; i < Et.estados.length; i++) {
          totalCasos = (totalCasos + dados[Et.estados[i]]["confirmed"].toInt());
          totalMortes = (totalMortes + dados[Et.estados[i]]['deaths'].toInt());
        }
        carregado = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: carregado
              ? Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              "Total de casos" + totalCasos.toString(),
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              "Total de Mortes" + totalMortes.toString(),
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView.builder(
                          itemCount: Et.estados.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 100,
                              color: Colors.white10,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Estado: " +
                                        dados[Et.estados[index]]["name"],
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    "Confirmados: " +
                                        dados[Et.estados[index]]["confirmed"]
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    "Mortos: " +
                                        dados[Et.estados[index]]["deaths"]
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                )
              : Container(
                  child: Center(
                    child: Text("Carregando...",
                        style: TextStyle(
                          fontSize: 50,
                        )),
                  ),
                ),
        ),
      ),
    );
  }
}
