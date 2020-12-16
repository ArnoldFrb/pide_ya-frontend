import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/pedidos.dart';
import 'package:pide_ya/src/models/user.dart';
import 'package:pide_ya/src/pages/ask_fors.dart';
import 'package:pide_ya/src/pages/facturar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:pide_ya/src/pages/user_info.dart';

class HStorePage extends StatefulWidget {
  
  final String user;
  final String uid;

  HStorePage(
    this.user,
    this.uid,
  );
  
  @override
  _HStorePageState createState() => _HStorePageState();

  static const String ROUTE = "/hstore";

}

class _HStorePageState extends State<HStorePage> {

  Future<User> queryUser(String email) async {

    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/users',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List<Pedidos> listPedido(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Pedidos>((json) => Pedidos.fromJson(json)).toList();
  }

  Future<List<Pedidos>> fetchPedido() async {
    final response = await http.post(
      'http://192.168.20.29:4000/api/store/pedidos',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sid': widget.uid,
      })
    );
    return listPedido(response.body);
  }

  updateEstado(String pedidokey) async {
    await http.post(
      'http://192.168.20.29:4000/api/pedido/update_estado',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pedidoKey': pedidokey,
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Text(
                    "Home",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  )
                ]
              ),
              height: 60,
            ),
            Card(
              margin: const EdgeInsets.all(10.0),
              elevation: 20.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.amber,
                ),
                height: 170,
                child: FutureBuilder<User>(
                future: queryUser(widget.user),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(snapshot.data.photoURL.isEmpty ? 'https://firebasestorage.googleapis.com/v0/b/pide-ya-db.appspot.com/o/PideYa.png?alt=media&token=a9f2a265-3d4f-4f9c-9828-2d125b63a950' : snapshot.data.photoURL)
                            ),
                            title: Text(snapshot.data.displayName),
                            subtitle: Text(snapshot.data.direction),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UserInfoPage(
                                    snapshot.data.uid,
                                    snapshot.data.displayName,
                                    snapshot.data.email,
                                    snapshot.data.phoneNumber,
                                    snapshot.data.direction,
                                    snapshot.data.photoURL,
                                    false
                                  )
                                )
                              );
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.history),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AskForsPage(
                                      snapshot.data.uid,
                                    )
                                  )
                                );
                              }
                            ),
                          )
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Completados",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        )
                                      )
                                    ),
                                    Expanded(
                                      child: Text(
                                        "20",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.subtitle1
                                      )
                                    )
                                  ]
                                )
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Canelados",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        )
                                      )
                                    ),
                                    Expanded(
                                      child: Text(
                                        "5",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.subtitle1
                                      )
                                    )
                                  ]
                                )
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Rechazados",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        )
                                      )
                                    ),
                                    Expanded(
                                      child: Text(
                                        "5",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.subtitle1
                                      )
                                    )
                                  ]
                                )
                              )
                            ]
                          )
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
                ),
              )
            ),
            Card(
              elevation: 0.0,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: cPideYaAmber50,
                          child: IconButton(
                            color: cPideYaRedGray,
                            icon: Icon(Icons.shopping_cart_rounded),
                            onPressed: () {
                              print("OK");
                            }
                          )
                        ),
                        Text("Pedidos")
                      ]
                    )
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: cPideYaAmber50,
                          child: IconButton(
                            color: cPideYaRedGray,
                            icon: Icon(Icons.remove_shopping_cart_rounded),
                            onPressed: () {
                              print("OK");
                            }
                          )
                        ),
                        Text("Cancelados")
                      ]
                    )
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: cPideYaAmber50,
                          child: IconButton(
                            color: cPideYaRedGray,
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              print("OK");
                            }
                          )
                        ),
                        Text("Rechazados")
                      ]
                    )
                  )
                ]
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height - 310.0,
              child: FutureBuilder<List<Pedidos>>(
                future: fetchPedido(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        var pedido = snapshot.data[index];
                        return _listStore(context, pedido.detalle, pedido.fecha, pedido.costo, pedido.estado, pedido.pid, pedido.cid);
                      },
                    );
                  }else if(snapshot.hasError){
                    return Center(child: Text("${snapshot.error}"));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            )
          ]
        )
      ),
      resizeToAvoidBottomInset: false,
    );
  }
  
  Widget _listStore(context, String detalle, String fecha, String costo, String estado, String pedidoKey, String clienteKey){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(10.0),
      color: Colors.white,
      elevation: 5,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.amber[200],
                  width: 8,
                )
              ),
              child: Image.asset('assets/PideYa.png', fit: BoxFit.fitWidth),
            )
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  height: 90,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      child: Text(costo, style: Theme.of(context).textTheme.subtitle1,),
                    ),
                    title: Text(fecha),
                    subtitle: Text(estado),
                    trailing: IconButton(
                      onPressed: () {
                        updateEstado(pedidoKey);
                        setState(() {
                          
                        });
                      },
                      icon: Icon(Icons.directions_bike)
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FacturarPage(
                            clienteKey,
                            pedidoKey,
                            costo,
                            detalle
                          )
                        )
                      );
                    },
                  )
                ),
              ],
            )
          )
        ]
      )
    );
  }
}