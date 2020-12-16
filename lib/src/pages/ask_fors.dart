import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/pedidos.dart';
import 'package:pide_ya/src/models/user.dart';
import 'package:pide_ya/src/pages/facturar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AskForsPage extends StatefulWidget {
  
  final String uid;

  AskForsPage(
    this.uid,
  );

  @override
  _AskForsPageState createState() => _AskForsPageState();

  static const String ROUTE = "/askfors";

}

class _AskForsPageState extends State<AskForsPage> {

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
                  elevation: 10.0,
                  child: Container(
                    height: 85
                  )
                ),
                Opacity(
                  opacity: 1,
                  child: Container(
                    color: Colors.amber[400],
                    height: 85,
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
                )
              ]
            ),
            Container(
              height: MediaQuery.of(context).size.height - 110.0,
              child: FutureBuilder<List<Pedidos>>(
                future: fetchPedido(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        var pedido = snapshot.data[index];
                        return _listPedidos(context, pedido.pid, pedido.sid, pedido.fecha, pedido.costo);
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
  Widget _listPedidos(context, String pedidokey, String clientekey, String fecha, String costo){
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
              height: 95,
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
                  child: FutureBuilder<User>(
                    future: queryUser(clientekey),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return ListTile(
                          onTap: () {
                            //Navigator.pushNamed(context, FacturarPage.ROUTE);
                          },
                          leading: CircleAvatar(
                            radius: 37.0,
                            backgroundColor: Colors.white,
                            child: Text(costo+"\n"+fecha, style: Theme.of(context).textTheme.bodyText2,),
                          ),
                          title: Text(snapshot.data.displayName),
                          subtitle: Text(snapshot.data.direction),
                          isThreeLine: false,
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  )
                ),
              ]
            )
          )
        ]
      )
    );
  }
}