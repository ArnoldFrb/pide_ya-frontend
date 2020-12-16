import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/models/favorite.dart';
import 'package:pide_ya/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class FavoritePage extends StatefulWidget {
  
  final String uid;

  FavoritePage(
    this.uid,
  );

  @override
  _FavoritePageState createState() => _FavoritePageState();

  static const String ROUTE = "/favorite";

}

class _FavoritePageState extends State<FavoritePage> {

  List<Favorite> listFavorite(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Favorite>((json) => Favorite.fromJson(json)).toList();
  }

  Future<List<Favorite>> fetchFavorite() async {
    final response = await http.post(
      'http://192.168.20.29:4000/api/favorite',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'clientekey': widget.uid,
      })
    );
    return listFavorite(response.body);
  }

  deleteFavorite(String favoritekey) async {
    await http.post(
      'http://192.168.20.29:4000/api/favorite/delete',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'favoritekey': favoritekey
      }),
    );
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
                  margin: const EdgeInsets.all(0.0),
                  elevation: 10.0,
                  child: Container(
                    height: 90
                  ),
                ),
                Opacity(
                  opacity: 1,
                  child: Container(
                    color: Colors.amber[400],
                    height: 90,
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
                                  "FAVORITOS",
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
              ]
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100.0,
              child: FutureBuilder<List<Favorite>>(
                future: fetchFavorite(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        var favorite = snapshot.data[index];
                        return _listFavorite(context, favorite.favoritekey, favorite.tiendakey);
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

  Widget _listFavorite(context, String favoritekey, String tiendakey){
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
              child: Image.asset('assets/PideYa.png', fit: BoxFit.fitWidth),
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
              child: FutureBuilder<User>(
                future: queryUser(tiendakey),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(snapshot.data.displayName),
                      subtitle: Text(snapshot.data.direction),
                      trailing: IconButton(
                        onPressed: () {
                          deleteFavorite(favoritekey);
                          setState(() { });
                        },
                        icon: Icon(Icons.delete)
                      ),
                      isThreeLine: true,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
            )
          )
        ]
      )
    );
  }
}