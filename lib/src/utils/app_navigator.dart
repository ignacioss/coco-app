import 'package:coco_app/src/widgets/loadingOverlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:coco_app/src/ui/home/home.dart';

Route makeEasyRoute(context, Widget child) {
  return MaterialPageRoute(
    builder: (BuildContext context) => LoadingOverlay(
      child: child,
    ),
  );
}

class AppNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      makeEasyRoute(
        context,
        HomeScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
