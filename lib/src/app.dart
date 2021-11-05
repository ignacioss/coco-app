import 'dart:async';

import 'package:coco_app/src/app/api_consts.dart';
import 'package:coco_app/src/blocs/app_bloc.dart';
import 'package:coco_app/src/utils/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:coco_app/theme/app_theme_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class AppInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: appThemeData,
        debugShowCheckedModeBanner: false,
        home: App(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es'),
        ],
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () async {
      goToMainMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(40),
            alignment: Alignment(0, 0),
            child: Image.asset(
              "lib/assets/imagenes/logo.png",
              scale: 4,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Developed for Suarez Smith Ignacio',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
        ],
      ),
    );
  }

  void goToMainMenu() async {
    AppNavigator.goToHome(context);
  }

}
