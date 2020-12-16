import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/producto.dart';
import 'package:pide_ya/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class FacturarPage extends StatefulWidget {

  final String clientekey;
  final String pedidokey;
  final String costo;
  final String detalle;

  const FacturarPage(
    this.clientekey,
    this.pedidokey,
    this.costo,
    this.detalle,
  );

  @override
  _FacturarPageState createState() => _FacturarPageState();

  static const String ROUTE = "/facturar";

}

class _FacturarPageState extends State<FacturarPage> {

  final _costoController = TextEditingController();
  final _comentarioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<User> queryUser(String key) async {

    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/store/users',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': key
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

  List<Producto> listProductos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Producto>((json) => Producto.fromJson(json)).toList();
  }

  Future<List<Producto>> fetchProductos() async {
    final response = await http.post(
      'http://192.168.20.29:4000/api/producto',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pid': widget.pedidokey,
      })
    );
    return listProductos(response.body);
  }

  updatePedido(String costo, String detalle) async {
    await http.post(
      'http://192.168.20.29:4000/api/pedido/update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'pedidoKey': widget.pedidokey,
        'costo': costo,
        'detalle': detalle,
      }),
    );
  }

  updateRechazar(String pedidokey) async {
    await http.post(
      'http://192.168.20.29:4000/api/pedido/update_rechazar',
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
            Stack(
              children: <Widget> [
                Card(
                  margin: const EdgeInsets.all(0),
                  elevation: 5,
                  child: Container(
                  height: 105
                )
                ),
                Opacity(
                  opacity: 1,
                  child: FutureBuilder<User>(
                  future: queryUser(widget.clientekey),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        color: Colors.amber[400],
                        height: 105,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      color: cPideYaRedGray,
                                      icon: Icon(Icons.keyboard_arrow_left), 
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      snapshot.data.displayName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                      )
                                    )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      color: cPideYaRedGray,
                                      icon: Icon(Icons.call), 
                                      onPressed: () {
                                        print("OK");
                                      },
                                    )
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(child: Container()),
                                  Text(
                                    snapshot.data.direction,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    "costo: "+widget.costo,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            )
                          ]
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              ]
            ),
             Container(
              height: 80.0,
              child: Center(child: Text(widget.detalle.isEmpty ? "Comentario" : widget.detalle)),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 350.0,
              child: FutureBuilder<List<Producto>>(
                future: fetchProductos(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        var producto = snapshot.data[index];
                        return _listPedidos(context, producto.producoKey, producto.producto, producto.detalle);
                      },
                    );
                  }else if(snapshot.hasError){
                    return Center(child: Text("${snapshot.error}"));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            ),
            SizedBox(height: 10),
            Center(
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: FlatButton(
                      onPressed: () {
                        updateRechazar(widget.pedidokey);
                        setState(() { });
                      }, 
                      child: Text("Rechazar")
                    )
                  ),
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: RaisedButton(
                      elevation: 5,
                      child: Text(
                        "Aceptar",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      onPressed: () {
                        _showMyDialog(context, _costoController, _comentarioController);
                      },
                    )
                  ),
                  Expanded(child: SizedBox()),
                ]
              )
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 120,
                height: 50,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text("Cancelar")
                )
              )
            )
          ]
        )
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _listPedidos(context, String productokey, String producto, String detalles){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(5.0),
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
        height: 90,
        child: ListTile(
          title: Text(producto),
          subtitle: Text(detalles),
          trailing: IconButton(
            color: cPideYaRedGray,
            icon: Icon(Icons.check_circle),
            onPressed: () {
              print("OK");
            }
          )
        )
      )
    );
  }

  Future<void> _showMyDialog(context, _costoController, _comentarioController) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _costoController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          //filled: true,
                          labelText: 'Costo',
                        ),
                      ),
                      // spacer
                      SizedBox(height: 12.0),
                      // [Password]
                      TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _comentarioController,
                        decoration: InputDecoration(
                          //filled: true,
                          labelText: 'Detalle',
                        ),
                      ),
                      ButtonBar( 
                        children: [
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _costoController.clear();
                              _comentarioController.clear();
                            }, 
                            child: Text("Cancelar")
                          ),
                          RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                updatePedido( _costoController.text, _comentarioController.text);
                                Navigator.pop(context);
                              }
                              _costoController.clear();
                              _comentarioController.clear();
                            },
                            child: Text("ENVIAR")
                          ),
                        ]
                      )
                    ]
                  )
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
