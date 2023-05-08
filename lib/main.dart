import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:farmacos_el_bueno/views/detailScreen.dart';
import 'package:farmacos_el_bueno/views/searchDelegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'views/login.dart';

void main() {
  runApp(MyApp());
}

Future<void> _endsession(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.push(context, MaterialPageRoute(builder: (context) => loginPage()));
}

Future<List<Farmaco>> getFarmacos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // var token = await prefs.getString("token");
  var token = "1|ryz9f1ePl3pNCm56sUQbyVbRNkJPzCEm2YpASeFJ";
  var headersList = {
    'Accept': '*/*',
    'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    'Authorization': 'Bearer ' + token!
  };
  print(token);

  var url = Uri.parse('http://farmacos.unav.edu.mx/api/v1/farmacos');
  var req = http.Request('GET', url);
  req.headers.addAll(headersList);
  //Creating a list to store input data;
  var res = await req.send();
  final resBody = await res.stream.bytesToString();
  if (res.statusCode >= 200 && res.statusCode < 300) {
    //print(resBody);
  } else {
    print(res.reasonPhrase);
  }
  final List<dynamic> jsonData = json.decode(resBody)['data'];

  final List _data = jsonData;

  return jsonData.map((json) => Farmaco.fromJson(json)).toList();
}

class Farmaco {
  final int id;
  final String farmaco;
  final String mecanismo;
  final String url;
  final String efecto;
  // final String recomendaciones;
  // final int id_bibliografia;
  final int id_grupo;
  final int estatus;

  Farmaco(
      {required this.id,
      required this.farmaco,
      required this.mecanismo,
      required this.url,
      required this.efecto,
      // required this.recomendaciones,
      // required this.id_bibliografia,
      required this.id_grupo,
      required this.estatus});

  factory Farmaco.fromJson(Map<String, dynamic> json) {
    return Farmaco(
      id: json['id'],
      farmaco: json['farmaco'],
      mecanismo: json['mecanismo'],
      url: json['url'],
      efecto: json['efecto'],
      // recomendaciones: json['recomendaciones'],
      // id_bibliografia: json['id_bibliografia'],
      id_grupo: json['id_grupo'],
      estatus: json['estatus'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Farmaco> farmacos = [];
  Future<void> verificasession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final token = await prefs.getString("token");
    final token = "1|ryz9f1ePl3pNCm56sUQbyVbRNkJPzCEm2YpASeFJ";
    print(token);
    if (!prefs.containsKey("token")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => loginPage()));
    } else {
      print(token);
      print("Si hay token");
    }
  }

  getdatafarmacos() async {
    farmacos = await getFarmacos();
    //puedes llamar a setState aquí para refrescar el widget
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: getFarmacos(),
  //     builder: (BuildContext ctx, AsyncSnapshot snapshot) {
  //       if (snapshot.data == null) {
  //         return Container(
  //           child: Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         );
  //       } else {
  //         return ListView.builder(
  //           itemCount: snapshot.data.length,
  //           itemBuilder: (ctx, index) => farm
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    verificasession();
    getdatafarmacos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Color(0xFFC8DDC8),
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
            actions: [
              PopupMenuButton(itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Logout"),
                  ),
                ];
              }, onSelected: (value) {
                if (value == 0) {
                  _endsession(context);
                }
              }),
            ],
            title: IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: searchFarmacos(farmacos));
                },
                icon: const Icon(Icons.search))),
        body: Center(
          child: FutureBuilder(
            future: getFarmacos(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) => ListTile(
                    // title: Text(snapshot.data[index].title),
                    title: Text(snapshot.data[index].farmaco),
                    tileColor: Color.fromARGB(255, 187, 222, 170),
                    onTap: () {
                      Navigator.push(
                          ctx,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  detailScreen(farmaco: snapshot.data[index])));
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
