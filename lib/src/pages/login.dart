import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pide_ya/src/models/type.dart';
import 'package:pide_ya/src/pages/home.dart';
import 'dart:convert';
import 'package:pide_ya/src/pages/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

  static const String ROUTE = "/login";
}

class _LoginPageState extends State<LoginPage> {
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool status;

  // ignore: missing_return
  Future<UserType> authUser(String email) async {

    final http.Response response = await http.post(
      'http://192.168.20.29:4000/api/users/auth',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    setState(() {
      status = true;
    });
    return UserType.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    status = false;
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
              SizedBox(height: 60.0),
              Column(
                children: <Widget>[
                  Image.asset('assets/Pide_Ya.png'),
                  SizedBox(height: 16.0),
                  Text(
                    'Tus Domicilios a la mano',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 80.0),
                  Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        //filled: true,
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      enabled: false,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        //filled: true,
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      height: 50,
                      width: 300,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: () async {
                          var data = await authUser(_usernameController.text);
                          if (status == true) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Home(
                                  data.type,
                                  data.uid,
                                  _usernameController.text
                                )
                              )
                            );
                          }
                        },
                        child: Text("Login", style: Theme.of(context).textTheme.headline6,)
                      )
                    ),
                  ]
                )
              ),
              SizedBox(height: 50.0),
              Column(
                children: [
                  Text(
                    'Presiona SingUp para registrarte',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpPage.ROUTE);
                    }, 
                    child: Text("SingUp", style: Theme.of(context).textTheme.headline6,),
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}