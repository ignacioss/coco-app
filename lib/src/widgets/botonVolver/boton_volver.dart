import 'package:coco_app/src/utils/app_icons.dart';
import 'package:flutter/material.dart';

class BotonVolver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(
        maxHeight: 50,
      ),
      padding: EdgeInsets.all(10),
      highlightColor: Colors.transparent,
      splashColor: Colors.white12,
      onPressed: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
