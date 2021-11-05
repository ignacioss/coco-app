import 'package:coco_app/src/utils/app_icons.dart';
import 'package:flutter/material.dart';

class BotonOpciones extends StatelessWidget {
  final BuildContext parentContext;
  final Function onBorrar;

  BotonOpciones({required this.parentContext, required this.onBorrar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 7),
      child: RawMaterialButton(
        fillColor: Colors.black26,
        elevation: 0,
        highlightElevation: 0,
        constraints: BoxConstraints(minHeight: 50, minWidth: 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        highlightColor: Colors.transparent,
        splashColor: Colors.white12,
        onPressed: _onMostrarOpciones,
        child: Icon(Icons.menu),
      ),
    );
  }

  void _onMostrarOpciones() async {
    switch (await showDialog<int>(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Opciones'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: const Text('Borrar'),
              ),
            ],
          );
        })) {
      case 0:
        onBorrar();
        break;
    }
  }
}
