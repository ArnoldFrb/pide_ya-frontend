import 'package:flutter/material.dart';
import 'package:pide_ya/src/pages/home_people.dart';
import 'package:pide_ya/src/pages/home_store.dart';

class Home extends StatefulWidget {

  final String type;
  final String email;
  final String uid;

  Home(
    this.type,
    this.uid,
    this.email,
  );

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == "Persona") {
      return HomePPage(widget.email);
    } else {
      return HStorePage(widget.email, widget.uid);
    }
  }
}
