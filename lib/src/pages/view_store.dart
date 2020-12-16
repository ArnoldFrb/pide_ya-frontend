import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/pedido.dart';
import 'package:pide_ya/src/models/pedidos.dart';
import 'package:pide_ya/src/pages/list_products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'map.dart';

class VStorePage extends StatefulWidget {

  final String sid;
  final String displayName;
  final String direction;
  final String photoUrl;
  final String uid;

  VStorePage(
    this.sid,
    this.displayName,
    this.direction,
    this.photoUrl,
    this.uid,
  );

  @override
  _VStorePageState createState() => _VStorePageState();

  static const String ROUTE = "/vstore";

}

class _VStorePageState extends State<VStorePage> {

  String _sid;
  String _displayName;
  String _direction;
  String _photoUrl;
  String _cid;

  String pid;
  String hasEstado;

  bool stateCreate;

  DateTime now = new DateTime.now();

  String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]).toString();

  Future<Pedido> createPedido(String sid, String cid) async {
    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/pedido/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fecha': date,
        'cid': cid,
        'sid': sid
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Pedido.fromJson(jsonDecode(response.body));
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
      'http://192.168.20.29:4000/api/pedido',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cid': _cid,
        'sid': _sid
      })
    );
    return listPedido(response.body);
  }

  createFavorite(String clientekey, String tiendakey) async {
    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/favorite/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'clientekey': clientekey,
        'tiendakey': tiendakey,
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    setState(() {
      stateCreate = true;
    });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  updateAceptar(String pedidokey) async {
    await http.post(
      'http://192.168.20.29:4000/api/pedido/update_aceptar',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pedidoKey': pedidokey,
      }),
    );
  }

  updateRechazar(String pedidokey) async {
    await http.post(
      'http://192.168.20.29:4000/api/pedido/update_cancelar',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pedidoKey': pedidokey,
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    _sid = widget.sid;
    _displayName = widget.displayName;
    _direction = widget.direction;
    _photoUrl = widget.photoUrl;
    _cid = widget.uid;

    stateCreate = false;
    hasEstado = "pedido";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: <Widget> [
                Container(
                  height: 300
                ),
                Container(
                  height: 250,
                  color: cPideYaAmber300,
                  child: Center(
                    child: Image.network(_photoUrl, fit: BoxFit.fitWidth)
                  )
                ),
                Opacity(
                  opacity: 1,
                  child: Container(
                    color: Colors.white10,
                    height: 250,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_left), 
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  _displayName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  )
                                )
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  icon: Icon(Icons.favorite), 
                                  onPressed: () {
                                    createFavorite(widget.uid, widget.sid);
                                  },
                                )
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(),
                        )
                      ]
                    ),
                  )
                ),
                Positioned(
                  bottom: 0.0,
                  right: 20,
                  left: 20,
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.amber[400],
                      ),
                      height: 100,
                      child: Center(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container()
                            ),
                            Text(
                              "DIR: " + _direction,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              )
                            ),
                            IconButton(
                              icon: Icon(Icons.map, color: cPideYaRedGray), 
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MapPage(
                                      "CALLE",
                                      "CLL",
                                    )
                                  )
                                );
                              }
                            ),
                            Expanded(
                              flex: 1,
                              child: Container()
                            ),
                          ]
                        )
                      )
                    )
                  )
                )
              ]
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
                            icon: Icon(Icons.add_shopping_cart_rounded),
                            onPressed: () async {
                              var data = await createPedido(_sid, _cid);
                              setState(() {
                                pid = data.pid;
                                hasEstado = "pedido";
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LProductsPage(
                                    pid,
                                    ""
                                  )
                                )
                              );
                            }
                          )
                        ),
                        Text("Pedir")
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
                              setState(() {
                                hasEstado = "cancelado";
                              });
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
                              setState(() {
                                hasEstado = "rechazado";
                              });
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
            Container(
              height: MediaQuery.of(context).size.height - 220.0,
              child: FutureBuilder<List<Pedidos>>(
                future: fetchPedido(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        var pedido = snapshot.data[index];
                        return _listPedidos(context, pedido.pid, pedido.detalle, pedido.sid, pedido.cid, pedido.fecha, pedido.costo, pedido.estado);
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

  Widget _listPedidos(context, String pedidokey, String detalle, String tiendakey, String clientekey, String fecha, String costo, String estado){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(10.0),
      color: Colors.white,
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.amber[200],
            width: 8,
          )
        ),
        height: 100,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.white,
                        child: Text(costo, style: Theme.of(context).textTheme.subtitle1,),
                      ),
                      title: Text(fecha),
                      subtitle: Text("Estado: "+estado),
                      isThreeLine: false,
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LProductsPage(
                              pedidokey,
                              detalle
                            )
                          )
                        );
                      },
                    )
                  ),
                ]
              )
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                color: cPideYaRedGray,
                icon: Icon(Icons.check_circle),
                onPressed: () {
                  updateAceptar(pedidokey);
                  setState(() { });
                }
              )
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                color: cPideYaRedGray,
                icon: Icon(Icons.cancel),
                onPressed: () {
                  updateRechazar(pedidokey);
                  setState(() { });
                }
              )
            )
          ]
        ),
      )
    );
  }
}