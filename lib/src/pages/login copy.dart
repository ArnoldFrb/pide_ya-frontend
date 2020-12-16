import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pide_ya/src/models/user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pide_ya/src/pages/signup.dart';

class Borrador extends StatefulWidget {
  @override
  _BorradorState createState() => _BorradorState();

  static const String ROUTE = "/login";
}

class _BorradorState extends State<Borrador> {
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<User> fetchUSer() async {
    final response = await http.get('http://192.168.20.29:4000/api/users');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUSer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                //filled: true,
                labelText: 'Username',
              ),
            ),
            // spacer
            SizedBox(height: 12.0),
            // [Password]
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                //filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: [
                FlatButton(
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  }, 
                  child: Text("Cancelar")
                ),
                RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Login")
                )
              ],
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
                ),
                FutureBuilder<User>(
                  future: futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.phoneNumber);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}
/*
content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RaisedButton(
                  elevation: 2.5,
                  color: person ? cPideYaAmber400 : cPideYaAmber50,
                  onPressed: () {
                    setState(() {
                      hasType = "Persona";
                      disableButton = true;
                      person = !person;
                    });
                  },
                  child: Text("Persona"),
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
                    });
                  },
                  child: Center(child: Text("Tienda")),
                ),
                Text(hasType),
              ],
            ),
          )*/