import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/store.dart';
import 'package:pide_ya/src/models/user.dart';
import 'package:pide_ya/src/pages/ask_for.dart';
import 'package:pide_ya/src/pages/direction.dart';
import 'package:pide_ya/src/pages/favorite.dart';
import 'package:pide_ya/src/pages/map.dart';
import 'package:pide_ya/src/pages/user_info.dart';
import 'package:pide_ya/src/pages/view_store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePPage extends StatefulWidget {
  
  final String user;

  HomePPage(
    this.user
  );
  
  @override
  _HomePPageState createState() => _HomePPageState();

  static const String ROUTE = "/homep";

}

class _HomePPageState extends State<HomePPage> {

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
  
  List<Store> listStore(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Store>((json) => Store.fromJson(json)).toList();
  }

  Future<List<Store>> fetchStore() async {
    final response = await http.get('http://192.168.20.29:4000/api/users/store');

    return listStore(response.body);
  }

  var _fetchStore;
  Future<User> futureUser;
  String cid;

  setup() async {
    var data = await queryUser(widget.user);
    setState(() {
      cid = data.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStore = fetchStore();
    setup();
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
                      //cid = snapshot.data.uid;
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
                                        true
                                      )
                                    )
                                  );
                                },
                              )
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(Icons.map, color: cPideYaRedGray), 
                                            onPressed: () {
                                              Navigator.pushNamed(context, MapPage.ROUTE);
                                            }
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Mapa",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            )
                                          )
                                        )
                                      ]
                                    )
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(Icons.place, color: cPideYaRedGray), 
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => DirectionPage(
                                                    snapshot.data.uid,
                                                  )
                                                )
                                              );
                                            }
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Direccion",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            )
                                          )
                                        )
                                      ]
                                    )
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(Icons.shopping_basket, color: cPideYaRedGray), 
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => AskForPage(
                                                    snapshot.data.uid,
                                                  )
                                                )
                                              );
                                            }
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Pedidos",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            )
                                          )
                                        )
                                      ]
                                    )
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(Icons.favorite, color: cPideYaRedGray), 
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => FavoritePage(
                                                    snapshot.data.uid,
                                                  )
                                                )
                                              );
                                            }
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Favorito",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            )
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
            Container(
              height: MediaQuery.of(context).size.height - 220.0,
              child: FutureBuilder<List<Store>>(
                future: _fetchStore,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        var store = snapshot.data[index];
                        return _listStore(context, store.uid, store.displayName, store.direction, store.photoURL, cid);
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
}

Widget _listStore(context, String sid, String displayName, String direction, String photoUrl, String uid){
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
            child: Image.network(photoUrl, fit: BoxFit.fitWidth),
          )
        ),
        SizedBox(width: 5.0),
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0)
            ),
            height: 90,
            child: ListTile(
              title: Text(displayName),
              subtitle: Text(direction),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VStorePage(
                        sid,
                        displayName,
                        direction,
                        photoUrl,
                        uid
                      )
                    )
                  );
                },
                icon: Icon(Icons.more)
              ),
              isThreeLine: true,
            )
          )
        )
      ]
    )
  );
}