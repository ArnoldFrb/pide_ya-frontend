import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/direction.dart';

class DirectionPage extends StatefulWidget {

  final String userkey;

  DirectionPage(
    this.userkey,
  );

  @override
  _DirectionPageState createState() => _DirectionPageState();

  static const String ROUTE = "/direction";

}

class _DirectionPageState extends State<DirectionPage> {

  final _nameController = TextEditingController();
  final _directionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  createDirection(String name, String direction) async {
    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/direction/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'direction': direction,
        'name': name,
        'userkey': widget.userkey,
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    setState(() { });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  updateDirection(String directionKey, String name, String direction) async {
    await http.post(
      'http://192.168.20.29:4000/api/direction/update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'directionKey': directionKey,
        'name': name,
        'direction': direction,
      }),
    );
  }

  updateEstado(String directionKey, String estado) async {
    await http.post(
      'http://192.168.20.29:4000/api/direction/update_estado',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'directionKey': directionKey,
        'estado': estado,
      }),
    );
  }

  deleteDirection(String directionKey) async {
    await http.post(
      'http://192.168.20.29:4000/api/direction/delete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'directionKey': directionKey
      }),
    );
  }

  List<Direction> listDirection(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Direction>((json) => Direction.fromJson(json)).toList();
  }

  Future<List<Direction>> fetchDirections() async {
    final response = await http.post(
      'http://192.168.20.29:4000/api/direction',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userkey': widget.userkey
      })
    );
    return listDirection(response.body);
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
                  height: 150
                ),
                Opacity(
                  opacity: 1,
                  child: Container(
                    color: Colors.amber[400],
                    height: 115,
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
                                  "PEDIDO",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                  )
                                )
                              ),
                              Expanded(
                                flex: 2,
                                child: Container()
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
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
                        color: Colors.white,
                      ),
                      height: 60,
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container()
                            ),
                            Expanded(
                              child: Icon(
                                Icons.map,
                                color: cPideYaRedGray
                              )
                            ),
                            Expanded(
                              child: Text("Mapa")
                            ),
                            Expanded(
                              child: Container()
                            ),
                            Expanded(
                              child: IconButton(
                                color: cPideYaRedGray,
                                icon: Icon(Icons.add_circle_rounded),
                                onPressed: () {
                                  _showMyDialog(context, '', true);
                                },
                              )
                            ),
                            Expanded(
                              child: Text("Add")
                            ),
                            Expanded(
                              child: Container()
                            )
                          ]
                        )
                      )
                    )
                  )
                )
              ]
            ),
            Container(
              height: MediaQuery.of(context).size.height - 200.0,
              child: FutureBuilder<List<Direction>>(
                future: fetchDirections(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        var direction = snapshot.data[index];
                        return _listPedidos(context, direction.directionKey, direction.name, direction.direction, direction.estado);
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

  Future<void> _showMyDialog(context, String directionKey, bool flag) async {
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
                        controller: _nameController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          //filled: true,
                          labelText: 'Nombre',
                        ),
                      ),
                      // spacer
                      SizedBox(height: 12.0),
                      // [Password]
                      TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _directionController,
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
                              _nameController.clear();
                              _directionController.clear();
                            }, 
                            child: Text("Cancelar")
                          ),
                          RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                if (flag) {
                                  createDirection(_nameController.text, _directionController.text);
                                }
                                else{
                                  updateDirection(directionKey, _nameController.text, _directionController.text);
                                  setState(() { });
                                }
                                Navigator.pop(context);
                              }
                              _nameController.clear();
                              _directionController.clear();
                            },
                            child: Text("Agregar")
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

  Widget _listPedidos(context, String directionKey, String name, String direction, String estado){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(5.0),
      color: (estado == "1") ? Colors.amber[200] : Colors.white,
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
          onTap: () {

          },
          leading: IconButton(
            color: cPideYaRedGray,
            icon: Icon(Icons.edit),
            onPressed: () {
              _nameController.text = name;
              _directionController.text = direction;
              _showMyDialog(context, directionKey, false);
            }
          ),
          title: Text(name),
          subtitle: Text("DIR: " + direction),
          trailing: IconButton(
            color: cPideYaRedGray,
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteDirection(directionKey);
            }
          )
        )
      )
    );
  }
}