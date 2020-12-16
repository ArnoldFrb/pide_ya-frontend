import 'package:flutter/material.dart';
import 'package:pide_ya/colors/colors.dart';
import 'package:pide_ya/src/pages/ask_for.dart';
import 'package:pide_ya/src/pages/ask_fors.dart';
import 'package:pide_ya/src/pages/direction.dart';
import 'package:pide_ya/src/pages/facturar.dart';
import 'package:pide_ya/src/pages/favorite.dart';
import 'package:pide_ya/src/pages/home_people.dart';
import 'package:pide_ya/src/pages/home_store.dart';
import 'package:pide_ya/src/pages/list_products.dart';
import 'package:pide_ya/src/pages/login.dart';
import 'package:pide_ya/src/pages/map.dart';
import 'package:pide_ya/src/pages/user_info.dart';
import 'package:pide_ya/src/pages/view_store.dart';
import 'package:pide_ya/src/pages/signup.dart';


class PideYaApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pide Ya',
      theme: _cPideYaTheme,
      initialRoute: LoginPage.ROUTE,
      routes: {
        HomePPage.ROUTE : (_) => HomePPage(''),
        LoginPage.ROUTE : (_) => LoginPage(),
        VStorePage.ROUTE : (_) => VStorePage('','','','',''),
        LProductsPage.ROUTE : (_) => LProductsPage('',''),
        MapPage.ROUTE : (_) => MapPage('',''),
        DirectionPage.ROUTE : (_) => DirectionPage(''),
        AskForPage.ROUTE : (_) => AskForPage(''),
        FavoritePage.ROUTE : (_) => FavoritePage(''),
        HStorePage.ROUTE : (_) => HStorePage('',''),
        FacturarPage.ROUTE : (_) => FacturarPage('','','',''),
        AskForsPage.ROUTE : (_) => AskForsPage(''),
        SignUpPage.ROUTE: (_) => SignUpPage(),
        UserInfoPage.ROUTE : (_) => UserInfoPage('','','','','','', false)
      },
    );
  }
}

final ThemeData _cPideYaTheme = _buildPideYaheme();

ThemeData _buildPideYaheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: cPideYaRedGray,
    primaryColor: cPideYaAmber300,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: cPideYaAmber300,
      colorScheme: base.colorScheme.copyWith(
        secondary: cPideYaRedGray,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    scaffoldBackgroundColor: cPideYaBackgroundWhite,
    cardColor: cPideYaBackgroundWhite,
    textSelectionColor: cPideYaAmber100,
    errorColor: cPideYaErrorRed,
    
    textTheme: _buildPideYaTextTheme(base.textTheme),
    primaryTextTheme: _buildPideYaTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildPideYaTextTheme(base.accentTextTheme),
    
     primaryIconTheme: base.iconTheme.copyWith(
      color: cPideYaRedGray
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    )
  );
}

TextTheme _buildPideYaTextTheme(TextTheme base) {
  return base.copyWith(
    headline5: base.headline5.copyWith(
      fontWeight: FontWeight.w500,
    ),
    headline6: base.headline6.copyWith(
        fontSize: 19.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    bodyText1: base.bodyText1.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Heebo',
    displayColor: cPideYaRedGray,
    bodyColor: cPideYaRedGray,
  );
}