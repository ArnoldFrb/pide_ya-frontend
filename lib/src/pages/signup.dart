import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/user.dart';
import 'dart:async';
import 'dart:convert';

import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();

  static const String ROUTE = "/signup";
}

class _SignUpPageState extends State<SignUpPage> {
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _directionController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefeonoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool statusCreate;
  bool disableButton;

  bool store;
  bool person;

  // ignore: missing_return
  Future<User> createUser(String displayName, String email, String password, String phoneNumber, String direction, String type) async {

    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/users/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'displayName': displayName,
        'photoURL': 'https://firebasestorage.googleapis.com/v0/b/pide-ya-db.appspot.com/o/PideYa.png?alt=media&token=a9f2a265-3d4f-4f9c-9828-2d125b63a950',
        'direction': direction,
        'type': type
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    setState(() {
      statusCreate = true;
    });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  String hasType;
  Future<User> futureUser;

  Future<void> _showMyDialog(context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( 
          title: Text("¿Te registraras como Persona o Tienda?"),
          content: StatefulBuilder(  // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 125.0,
                child: Column(
                  children: [
                    RaisedButton(
                      elevation: 2.5,
                      color: person ? cPideYaAmber400 : cPideYaAmber50,
                      onPressed: () {
                        setState(() {
                          hasType = "Persona";
                          disableButton = true;
                          person = !person;
                          store = false;
                        });
                      },
                      child: Center(child: Text("Persona")),
                    ),
                    SizedBox(height: 5.0),
                    RaisedButton(
                      elevation: 2.5,
                      color:  store ? cPideYaAmber400 : cPideYaAmber50,
                      onPressed: () {
                        setState(() {
                          hasType = "Tienda";
                          disableButton = true;
                          store = !store;
                          person = false;
                        });
                      },
                      child: Center(child: Text("Tienda")),
                    ),
                  ]
                ),
              );
            },
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
                if (disableButton) {
                  createUser(_usernameController.text, _emailController.text, _passwordController.text, '+57' + _telefeonoController.text, _directionController.text, hasType);
                  Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.ROUTE, (Route<dynamic> route) => false);
                  setState(() {
                    disableButton = false;
                  });
                }
              },
              child: Text("Crear")
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    hasType = 'Confirme su tipo de usuario';
    statusCreate = false;
    disableButton = false;
    store = false;
    person = false;
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
                  Expanded(flex: 7, child: Text("LOGIN"))
                ],
              ),
              SizedBox(height: 15.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/Pide_Ya.png'),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Container(),),
                      Text(
                        'Sign UP',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Expanded(flex: 1, child: Container(),)
                    ]
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      controller: _usernameController,
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
                    // [Password]
                    TextFormField(
                      controller: _passwordController,
                      validator: (value){
                        if (value.length < 6) {
                          return "6 Caracteres o mas";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        //filled: true,
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
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
                      textCapitalization: TextCapitalization.characters,
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
                            _emailController.clear();
                            _telefeonoController.clear();
                            _directionController.clear();
                            _usernameController.clear();
                            _passwordController.clear();
                            Navigator.pop(context);
                          }, 
                          child: Text("Cancelar")
                        ),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _showMyDialog(context);
                              }
                            },
                            child: Text("SingUp")
                          ),
                        )
                      ],
                    )
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}