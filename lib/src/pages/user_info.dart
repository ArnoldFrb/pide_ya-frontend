import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pide_ya/src/pages/login.dart';

class UserInfoPage extends StatefulWidget {

  final String uid;
  final String displayName;
  final String email;
  final String phoneNumbre;
  final String direction;
  final String photoURL;
  final bool type;


  UserInfoPage(
    this.uid,
    this.displayName,
    this.email,
    this.phoneNumbre,
    this.direction,
    this.photoURL,
    this.type,
  );

  @override
  _UserInfoPageState createState() => _UserInfoPageState();

  static const String ROUTE = "/userinfo";
  
}

class _UserInfoPageState extends State<UserInfoPage> {
  
  String uidController;
  final usernameController = TextEditingController();
  final _directionController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefeonoController = TextEditingController();
  String photoController;

  final _formKey = GlobalKey<FormState>();

  bool statusUpdate;
  bool statusDelete;

  updateUser(String displayName, String email, String phoneNumber, String direction, String photoURL, String uid) async {

    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/users/update',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'email': email,
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'direction': direction,
        'photoURL': photoURL,
        'type': widget.type ? "Persona" : "Tienda",
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    setState(() {
      statusUpdate = true;
    });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  deleteUser(String uid) async {

    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/users/delete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    setState(() {
      statusDelete = true;
    });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to delete user');
    }
  }

  Future<void> _showMyDialog(context, String uidController) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("¿ Esta seguto de barrar su cuenta ?")
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text("Cancelar")
            ),
            RaisedButton(
              elevation: 5.0,
              onPressed: () {
                deleteUser(uidController);
                if (statusDelete) {
                  Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.ROUTE, (Route<dynamic> route) => false);
                  setState(() {
                    statusDelete = false;
                  });
                }
              },
              child: Text("Borrar")
            ),
          ],
        );
      },
    );
  }

  bool textEnable = false; 

  @override
  void initState() {
    super.initState();
    uidController = widget.uid;
    usernameController.text = widget.displayName;
    _emailController.text = widget.email;
    _directionController.text = widget.direction;
    _telefeonoController.text = widget.phoneNumbre;
    photoController = widget.photoURL;

    statusUpdate = false;
    statusDelete = false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                    )
                  ),
                  Expanded(flex: 4, child: Text("USER")),
                  Expanded(flex: 3, 
                    child: FlatButton(
                      onPressed: () {
                        _showMyDialog(context, uidController);
                      },
                      child: Text("Borrar cuenta"),
                    )
                  )
                ],
              ),
              SizedBox(height: 5.0),
              Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(photoController.isEmpty ? 'https://firebasestorage.googleapis.com/v0/b/pide-ya-db.appspot.com/o/PideYa.png?alt=media&token=a9f2a265-3d4f-4f9c-9828-2d125b63a950' : photoController)
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Container(),),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Editar"),
                          onPressed: () {
                            setState(() {
                              textEnable = true;
                            });
                          },
                        )
                      ),
                      Expanded(flex: 1, child: Container(),),

                    ]
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      enabled: textEnable,
                      controller: usernameController,
                      validator: (value){
                        if (value.isEmpty) {
                          return "Dato faltante";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //filled: true,
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Nombre',
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      enabled: textEnable,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value){
                        if (value.isEmpty) {
                          return "Dato faltante";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //filled: true,
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                    ),
                    // spacer
                    SizedBox(height: 12.0),
                    TextFormField(
                      enabled: textEnable,
                      keyboardType: TextInputType.phone,
                      maxLength: 13,
                      controller: _telefeonoController,
                      validator: (value){
                        if (value.isEmpty) {
                          return "Dato faltante";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //filled: true,
                        prefixIcon: Icon(Icons.call),
                        labelText: 'Telefeno',
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      enabled: textEnable,
                      controller: _directionController,
                      validator: (value){
                        if (value.isEmpty) {
                          return "Dato faltante";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        //filled: true,
                        prefixIcon: Icon(Icons.person_pin_circle),
                        labelText: 'Direccion',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ButtonBar(
                      children: [
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              textEnable = false;
                            });
                          }, 
                          child: Text("Cancelar")
                        ),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              if (_formKey.currentState.validate() && textEnable == true) {
                                updateUser(usernameController.text, _emailController.text, _telefeonoController.text, _directionController.text, photoController, uidController);
                                //Navigator.pop(context);
                                FocusScope.of(context).requestFocus(new FocusNode());
                              }
                            },
                            child: Text("Guardar")
                          ),
                        )
                      ],
                    )
                  ]
                )
              ),
              SizedBox(height: 5.0),
              Center(child: Text(statusUpdate ? 'Se actualizo de manera correcta' : ''))
            ],
          ),
        ),
      ),
    );
  }
}