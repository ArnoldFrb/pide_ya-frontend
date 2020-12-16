import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pide_ya/src/models/producto.dart';

class LProductsPage extends StatefulWidget {

  final String pid;
  final String detalle;

  LProductsPage(
    this.pid,
    this.detalle,
  );

  @override
  _LProductsPageState createState() => _LProductsPageState();

  static const String ROUTE = "/lproducts";

}

class _LProductsPageState extends State<LProductsPage> {

  final _productsController = TextEditingController();
  final _detalleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _pid;

  bool stateCreate;

  createProducto(String producto, String detalle) async {
    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/producto/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'producto': producto,
        'detalle': detalle,
        'pid': _pid,
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

  updateProducto(String productoKey, String producto, String detalle) async {
    await http.post(
      'http://192.168.20.29:4000/api/producto/update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'productoKey': productoKey,
        'producto': producto,
        'detalle': detalle,
      }),
    );
  }

  deleteProducto(String productoKey) async {
    await http.post(
      'http://192.168.20.29:4000/api/producto/delete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'productoKey': productoKey
      }),
    );
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
        'pid': _pid
      })
    );
    return listProductos(response.body);
  }

  @override
  void initState() {
    super.initState();

    _pid = widget.pid;
    //_fechtProductos = fetchProductos(_pid);
    stateCreate = false;
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
                                Icons.shopping_basket,
                                color: cPideYaRedGray
                              )
                            ),
                            Expanded(
                              child: Text("5")
                            ),
                            Expanded(
                              child: Container()
                            ),
                            Expanded(
                              child: IconButton(
                                color: cPideYaRedGray,
                                icon: Icon(Icons.add_circle_rounded),
                                onPressed: () {
                                  _showMyDialog(context, '',true);
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
                        return _listProducto(context, producto.producoKey, producto.pid, producto.producto, producto.detalle);
                      },
                    );
                  }else if(snapshot.hasError){
                    return Center(child: Text("${snapshot.error}"));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 120,
                height: 50,
                child: RaisedButton(
                  elevation: 5,
                  child: Text(
                    "Enviar",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              )
            )
          ]
        )
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _showMyDialog(context, String productoKey, bool flag) async {
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
                        controller: _productsController,
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
                        controller: _detalleController,
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
                              _productsController.clear();
                              _detalleController.clear();
                            }, 
                            child: Text("Cancelar")
                          ),
                          RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                if (flag) {
                                  createProducto(_productsController.text, _detalleController.text);
                                }
                                else{
                                  updateProducto(productoKey, _productsController.text, _detalleController.text);
                                }
                                Navigator.pop(context);
                              }
                              _productsController.clear();
                              _detalleController.clear();
                            },
                            child: Text("Guardar")
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

  Widget _listProducto(context, String productokey, String pid, String producto, String detalles){
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
          leading: IconButton(
            color: cPideYaRedGray,
            icon: Icon(Icons.edit),
            onPressed: () {
              _productsController.text = producto;
              _detalleController.text = detalles;
              _showMyDialog(context, productokey, false);
            }
          ),
          title: Text(producto),
          subtitle: Text(detalles),
          trailing: IconButton(
            color: cPideYaRedGray,
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteProducto(productokey);
              setState(() {});
            }
          )
        )
      )
    );
  }
}